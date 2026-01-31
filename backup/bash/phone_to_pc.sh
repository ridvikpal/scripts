#!/bin/bash

####################
# This script is used to backup folders from an Android phone using rsync
# and go-mtpfs.

# The folders to backup are stored in $FOLDERS_FILE
# and must have unique leaf names
####################

# Path to the file that contains the list of folders to back up
FOLDERS_FILE="../text/phone_folders_to_backup.txt"

# Ensure folders file exists
if [[ ! -f "${FOLDERS_FILE}" ]]; then
    echo "ERROR: Folder list file '${FOLDERS_FILE}' not found."
    exit 1
fi

# Load folders into an array
mapfile -t FOLDERS < "${FOLDERS_FILE}"

# Inform the user which folders are being backed up
echo ""
echo "Backing up the following folders from phone to pc:"
echo "---------------------------------"
for folder in "${FOLDERS[@]}"; do
    echo "${folder}"
done
echo ""

# Then ask for their confirmation to continue
read -rp "Continue? (Y/n) " -n 1
if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
    # if the user did not say yes, then exit
    exit 1
fi
echo ""

# The mount point to mount the phone's MTP file system via go-mtpfs
MOUNT_POINT="${HOME}/mnt/phone"
# Ensure the mount point has been created before proceeding
mkdir -p "${MOUNT_POINT}"

# Check if the phone has already been mounted
if mountpoint -q "${MOUNT_POINT}"; then
    echo "Device already mounted at ${MOUNT_POINT}"
# Else mount the phone
else
    echo "Attempting to mount phone with go-mtpfs..."
    go-mtpfs "${MOUNT_POINT}" &
    # Give MTP a moment to initialize by delaying for 3 seconds
    sleep 3
fi

# Verify mount success and exist if the mount failed
if ! mountpoint -q "${MOUNT_POINT}"; then
    echo "ERROR: Failed to mount phone. Is it plugged in with file transfer mode enabled?"
    read -rp "Press enter to exit..."
    exit 1
fi

# Get the phone's root data path
PHONE_DATA_PATH="${MOUNT_POINT}/Internal shared storage"
# Inform the user of the root folders that are visible
echo "The folders found at ${PHONE_DATA_PATH} are:"
ls "${PHONE_DATA_PATH}"

# Setup the backup path on pc
BACKUP_PATH="${HOME}/Phone"

# Inform the user the backup is starting
echo ""
echo "Starting backup to: ${BACKUP_PATH}"
echo "--------------------------------"

# Create the backup path if it doesn't exist.
mkdir -p "${BACKUP_PATH}"

# Backup each folder 1 by 1
for SRC in "${FOLDERS[@]}"; do
    # The full phone src data path
    FULL_SRC_PATH="${PHONE_DATA_PATH}/${SRC}"

    # Extract folder name (leaf)
    LEAF_NAME=$(basename "${SRC}")
    # Create the backup path using the leaf name
    DEST="${BACKUP_PATH}/${LEAF_NAME}"

    echo ""
    echo "Backing up '${FULL_SRC_PATH}' -> '${DEST}'"

    # Backup using rsync, ignoring system (.*) files
    # and other file properties since MTP doesn't support them
    rsync -rvh \
        --size-only \
        --no-perms \
        --no-times \
        --no-links \
        --delete-delay \
        --itemize-changes \
        --info=progress2 \
        --exclude='.*' \
        "${FULL_SRC_PATH}/" "${DEST}/"

    if [[ $? -ne 0 ]]; then
        echo "WARNING: rsync reported an issue for ${SRC}"
    fi
done

# Unmount the phone after backup
fusermount -u "${MOUNT_POINT}"
# Notify the user if the unmount was successful
if [[ $? -eq 0 ]]; then
    echo "Successfully unmounted phone from ${MOUNT_POINT}."
# Else notify the user the unmount was not successful
else
    echo "ERROR: Failed to unmount the phone from ${MOUNT_POINT}. The device may be busy..."
    read -rp "Press enter to exit..."
    exit 1
fi

# Inform the user the backup is completed.
echo ""
echo "Backup completed!"
read -rp "Press any key to exit... " -n 1
echo ""
