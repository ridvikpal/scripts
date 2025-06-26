# Define the path to 7z executable
$sevenZipPath = "C:\Program Files\7-Zip\7z.exe"

# Check if 7zip is installed
if (!(Test-Path -Path $sevenZipPath)) {
    throw "The 7zip executable was not found at $sevenZipPath. Please check your 7zip installation."
}

# Today's date to archive the backup
$date = (Get-Date).ToString('yyyy-MM-dd')

# The local backup directory path
$localBackupDirectory = "$env:USERPROFILE\Backup"

# Define the output archive path and name
$localArchive = "$localBackupDirectory\$date-backup.7z"  # Adjust output path and name as necessary

# Check if the backup folder exists and if not, then create it
if (!(Test-Path -PathType Container -Path $localBackupDirectory)) {
    New-Item -ItemType Directory -Path $localBackupDirectory
}

# The path of the txt file containing the folders to archive
$foldersToArchivePath = ".\folders.txt"

# Load the folders to backup from the txt file
$foldersToArchive = Get-Content -Path $foldersToArchivePath

# Inform the user which folders are being backed up
Write-Host "`nBacking up the following folders:`n"
foreach ($folder in $foldersToArchive) {
    Write-Host $folder
}
Write-Host "`nBackup will be stored in the $localArchive archive locally`n"

# Set the password file path
$passwordFilePath = ".\password.txt"

# If a file exists specifying a password, then use that password
if (!(Test-Path -Path $passwordFilePath)) {
    $password = "`"`""
} else {
    $password = Get-Content -Path $passwordFilePath -Raw
}

# Build the command to create the 7zip archive
$cmdArgs = @(
    "a",                    # 'a' means to add files to the archive
    "-p$password",               # Password protection
    $localArchive            # Output archive file name
    ) + $foldersToArchive   # Add the folders to include

# Run the 7z command with the specified arguments
Start-Process -FilePath $sevenZipPath -ArgumentList $cmdArgs -NoNewWindow -Wait

#Inform the user the backup was created locally
Write-Host "`n The backup archive was created locally`n"

# Ask the user for the external drive they want to backup the archive ot
$driveLetter = (Read-Host -Prompt "Please enter the external drive letter to backup archive to (make sure the drive is mounted)").ToUpper()

# Check if the external drive is mounted at that location
if (!(Test-Path -PathType Container -Path "${driveLetter}:")) {
    throw "Unable to detect the ${driveLetter}: drive. Please ensure it is properly mounted."
}

# The backup directory on the external drive
$backupDirectory = "${driveLetter}:\Backup"

# Check if the backup folder exists on the external drive and if not, then create it
if (!(Test-Path -PathType Container -Path $backupDirectory)) {
    New-Item -ItemType Directory -Path $backupDirectory
}

# Copy the archive to the external drive
Copy-Item $localArchive -Destination "$backupDirectory\" 

# Inform the user the backup archive was copied to the external drive
Write-Host "`nThe backup archive was copied to $backupDirectory\`n"

# Get the current timestamp
$timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

# Write the backup date information to the drive
Set-Content -Path "${driveLetter}:\backup_timestamp.txt" -Value "Backed up at ${timestamp}"

# Wait for the user to click enter to exit
Read-Host -Prompt "Backup completed. Press enter to exit"