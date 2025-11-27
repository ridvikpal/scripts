#!/bin/bash

# Path to the file that contains the list of folders to back up
FOLDERS_FILE="./folders.txt"

# Ensure folders file exists
if [[ ! -f "$FOLDERS_FILE" ]]; then
    echo "Error: Folder list file '$FOLDERS_FILE' not found."
    exit 1
fi

# Load folders into an array
mapfile -t FOLDERS < "$FOLDERS_FILE"

# Inform the user which folders are being backed up
echo ""
echo "Backing up the following folders:"
echo "---------------------------------"
for folder in "${FOLDERS[@]}"; do
    echo "$folder"
done

# Get the backup drive mountpoint from the user
echo ""
read -rp "Please enter the *mount point* of the backup drive (e.g. /media/user/backup): " DEST_DRIVE

# Validate drive path
if [[ ! -d "$DEST_DRIVE" ]]; then
    echo ""
    echo "Error: '$DEST_DRIVE' does not exist or is not mounted."
    read -rp "Press enter to exit..."
    exit 1
fi

# Get the computer hostname
HOSTNAME=$(hostname)
BACKUP_PATH="${DEST_DRIVE}/${HOSTNAME}"

# Inform the user the backup is starting
echo ""
echo "Starting backup to: $BACKUP_PATH"
echo "--------------------------------"

# Create the backup path if it doesn't exist.
mkdir -p "$BACKUP_PATH"

# Process each folder
for SRC in "${FOLDERS[@]}"; do
    # Extract folder name (leaf)
    LEAF_NAME=$(basename "$SRC")
    # Create the backup path using the leaf name
    DEST="${BACKUP_PATH}/${LEAF_NAME}"

    echo ""
    echo "Backing up '$SRC' -> '$DEST'"

    # rsync equivalent of robocopy /MIR /Z /XA:SH /R:3 /W:1
    rsync -avh \
        --no-links \
        --delete \
        --info=progress2 \
        --exclude='.*' \
        "$SRC"/ "$DEST"/

    if [[ $? -ne 0 ]]; then
        echo "Warning: rsync reported an issue for $SRC"
    fi
done

# Write timestamp
date '+%Y-%m-%d %H:%M:%S' > "${BACKUP_PATH}/timestamp.txt"

echo ""
echo "Backup completed!"
read -rp "Press enter to exit..."
