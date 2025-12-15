#!/bin/bash

# Path to the file that contains the list of folders to back up
FOLDERS_FILE="../text/phone_folders_to_backup.txt"

# Ensure folders file exists
if [[ ! -f "$FOLDERS_FILE" ]]; then
    echo "Error: Folder list file '$FOLDERS_FILE' not found."
    exit 1
fi

# Load folders into an array
mapfile -t FOLDERS < "$FOLDERS_FILE"

# Inform the user which folders are being backed up
echo ""
echo "Backing up the following folders from phone to pc:"
echo "---------------------------------"
for folder in "${FOLDERS[@]}"; do
    echo "$folder"
done

# Get the current user uid
USER_ID=$(id -u)
# The location of possible mountpoints for the phone
GVFS_PATH="/run/user/${USER_ID}/gvfs"

# Ask the user which phone they want to backup the notes from
mounted_phones=$(ls $GVFS_PATH)

echo ""
echo "Choose a mounted phone:"
select PHONE_MOUNT_NAME in "${mounted_phones[@]}"; do
    if [[ -n "$PHONE_MOUNT_NAME" ]]; then
        echo "You selected phone: $PHONE_MOUNT_NAME"
        break
    else
        echo "Invalid choice."
        read -rp "Press enter to exit..."
        exit 1
    fi
done

# Get the phone's root data path
PHONE_DATA_PATH="${GVFS_PATH}/${PHONE_MOUNT_NAME}/Internal shared storage"

# Setup the backup path on pc
BACKUP_PATH="/home/ridvikpal/Documents/Phone"

# Inform the user the backup is starting
echo ""
echo "Starting backup to: $BACKUP_PATH"
echo "--------------------------------"

# Create the backup path if it doesn't exist.
mkdir -p "$BACKUP_PATH"

# Backup each folder 1 by 1
for SRC in "${FOLDERS[@]}"; do
    # The full phone src data path
    FULL_SRC_PATH="${PHONE_DATA_PATH}/${SRC}"

    # Extract folder name (leaf)
    LEAF_NAME=$(basename "$SRC")
    # Create the backup path using the leaf name
    DEST="${BACKUP_PATH}/${LEAF_NAME}"

    echo ""
    echo "Backing up '$FULL_SRC_PATH' -> '$DEST'"

    # Backup using rsync, ignoring system (.*) files
    rsync -avh \
        --no-links \
        --delete \
        --info=progress2 \
        --exclude='.*' \
        "$FULL_SRC_PATH"/ "$DEST"/

    if [[ $? -ne 0 ]]; then
        echo "Warning: rsync reported an issue for $SRC"
    fi
done

# Inform the user the backup is completed.
echo ""
echo "Backup completed!"
read -rp "Press any key to exit... " -n 1
echo ""
