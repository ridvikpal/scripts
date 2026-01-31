#!/bin/bash

####################
# This script is used to backup folders from an Android phone using kioclient

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

# get all connected phones and load them into an array
mapfile -t CONNECTED_PHONES < <(kioclient ls "mtp:/" | sed '1d;$d')

# prompt the user choose a phone to backup files from
echo ""
echo "Choose a connected phone:"
select PHONE in "${CONNECTED_PHONES[@]}"; do
    if [[ -n "${PHONE}" ]]; then
        echo "You selected phone: ${PHONE}"
        break
    else
        echo "Invalid choice."
        read -rp "Press any key to exit..."
        exit 1
    fi
done

# Get the phone's storage name (e.g., Internal shared storage)
STORAGE_NAME=$(kioclient ls "mtp:/${PHONE}" | sed -n '2{p;q}')
# Inform the user if the storage name cannot be found
if [[ -z "${STORAGE_NAME}" ]]; then
    echo "ERROR: Could not find storage on ${PHONE}. Is File Transfer (MTP) mode enabled on the phone?"
    read -rp "Press any key to exit..."
        exit 1
fi

# Get the phone's root data path
PHONE_DATA_PATH="mtp:/${PHONE}/${STORAGE_NAME}"

# Setup the backup path on pc
BACKUP_PATH="${HOME}/Phone"
# Delete the backup path if it exists before proceeding
# because we want to overwrite it with new data
rm -rf "${BACKUP_PATH}"
# Create the backup path again.
mkdir "${BACKUP_PATH}"

# Inform the user the backup is starting
echo ""
echo "Starting backup to: ${BACKUP_PATH}"
echo "--------------------------------"

# Backup each folder 1 by 1
for SRC in "${FOLDERS[@]}"; do
    # The full phone src data path
    FULL_SRC_PATH="${PHONE_DATA_PATH}/${SRC}"

    # Extract folder name (leaf)
    LEAF_NAME=$(basename "${SRC}")

    echo ""
    echo "Backing up '${FULL_SRC_PATH}' -> '${BACKUP_PATH}/${LEAF_NAME}'"

    # Backup folder using kioclient
    kioclient copy "${FULL_SRC_PATH}" "${BACKUP_PATH}/"

    # inform the user if there was an error backing up a specific folder
    if [[ $? -ne 0 ]]; then
        echo "WARNING: kioclient reported an issue for ${SRC}"
    fi
done

# Inform the user the backup is completed.
echo ""
echo "Backup completed!"
read -rp "Press any key to exit... " -n 1
echo ""
