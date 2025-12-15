#!/bin/bash

####################
# This script is used to backup certain folders
# from an Ubuntu PC to an external drive using rsync.
####################

# Path to the file that contains the list of folders to back up
FOLDERS_FILE="../text/pc_folders_to_backup.txt"

# Ensure folders file exists
if [[ ! -f "$FOLDERS_FILE" ]]; then
    echo "Error: Folder list file '$FOLDERS_FILE' not found."
    exit 1
fi

# Load folders into an array
mapfile -t FOLDERS < "$FOLDERS_FILE"

# Inform the user which folders are being backed up
echo ""
echo "Backing up the following folders from PC to an external drive:"
echo "---------------------------------"
for folder in "${FOLDERS[@]}"; do
    echo "$folder"
done

# get all the mounted external drives
mounted_drive_paths=$(findmnt -l -o TARGET | grep /media)

# let the user choose an external drive from the available mounted drives.
echo ""
echo "Choose a mounted backup drive:"
select DRIVE_PATH in "${mounted_drive_paths[@]}"; do
    if [[ -n "$DRIVE_PATH" ]]; then
        echo "You selected backup drive mounted at: $DRIVE_PATH"
        break
    else
        echo "Invalid choice."
        read -rp "Press enter to exit..."
        exit 1
    fi
done

# Get the computer hostname
HOSTNAME=$(hostname)
BACKUP_PATH="${DRIVE_PATH}/${HOSTNAME}"

# Inform the user the backup is starting
echo ""
echo "Starting backup to: $BACKUP_PATH"
echo "--------------------------------"

# Create the backup path if it doesn't exist.
mkdir -p "$BACKUP_PATH"

# Backup each folder 1 by 1
for SRC_RAW in "${FOLDERS[@]}"; do
    # first get the full folder path
    # expanded in case it includes variables
    # such as $HOME
    SRC=$(eval echo "$SRC_RAW")

    # Extract folder name (leaf)
    LEAF_NAME=$(basename "$SRC")
    # Create the backup path using the leaf name
    DEST="${BACKUP_PATH}/${LEAF_NAME}"

    echo ""
    echo "Backing up '$SRC' -> '$DEST'"

    # Backup using rsync, ignoring system (.*) files
    rsync -avh \
        --no-links \
        --delete-delay \
        --itemize-changes \
        --info=progress2 \
        --exclude='.*' \
        "$SRC"/ "$DEST"/

    if [[ $? -ne 0 ]]; then
        echo "Warning: rsync reported an issue for $SRC"
    fi
done

# Inform the user the backup is completed.
echo ""
echo "Backup completed!"
read -rp "Press any key to exit... " -n 1
echo ""
