#!/bin/bash

# Path to the file that contains the list of folders to restore
FOLDERS_FILE="./pc_folders.txt"

# Ensure folders file exists
if [[ ! -f "$FOLDERS_FILE" ]]; then
    echo "Error: Folder list file '$FOLDERS_FILE' not found."
    exit 1
fi

# Load folders into an array
mapfile -t FOLDERS < "$FOLDERS_FILE"

# Inform the user which folders are being restored
echo ""
echo "Restoring the following folders from an external drive to PC:"
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

# Inform the user the restore is starting
echo ""
echo "Starting restore from: $BACKUP_PATH"
echo "--------------------------------"

# Ensure backup folder exists
if [[ ! -d "$BACKUP_PATH" ]]; then
    echo "Error: Backup parent folder '$BACKUP_PATH' not found."
    exit 1
fi

# Restore each folder 1 by 1
for DEST in "${FOLDERS[@]}"; do
    # Extract folder name (leaf)
    LEAF_NAME=$(basename "$DEST")
    # Create the backup path using the leaf name
    SRC="${BACKUP_PATH}/${LEAF_NAME}"

    echo ""
    echo "Restoring '$SRC' -> '$DEST'"

    # Restore using rsync, ignoring system (.*) files
    rsync -avh \
        --no-links \
        --delete \
        --info=progress2 \
        --exclude='.*' \
        "$SRC"/ "$DEST"/

    if [[ $? -ne 0 ]]; then
        echo "Warning: rsync reported an issue for $DEST"
    fi
done

# Inform the user the restore has been completed.
echo ""
echo "Restore completed!"
read -rp "Press enter to exit..."
