# The path of the txt file containing the folders to backup
$foldersToBackupPath = ".\folders.txt"

# Load the folders to backup from the txt file
$foldersToBackup = Get-Content -Path $foldersToBackupPath

# Inform the user which folders are being backed up
Write-Host "`nBacking up the following folders:`n"
foreach ($folder in $foldersToBackup) {
    Write-Host $folder
}

# Ask the user for the external drive they want to backup the archive ot
$driveLetter = (Read-Host -Prompt "`nPlease enter the external drive's mounted filesystem letter to backup the folders to").ToUpper()

# Check if the external drive is mounted at that location
if (!(Test-Path -PathType Container -Path "${driveLetter}:")) {
    # Inform the user of the error
    Write-Error "`nUnable to detect the ${driveLetter}: drive. Please ensure it is properly mounted, and then try again.`n"

    # Wait for the user to click enter to exit
    Read-Host -Prompt "`nPress enter to exit`n"
    throw
}

# Inform the user the backup is starting
Write-Host "`nStarting backup to ${driveLetter}: drive`n"

# Today's date to archive the backup
$timestamp = (Get-Date).ToString("yyyy.MM.dd.T.HH.mm.ss")

# Get the hostname of the machine
$hostname = (hostname);

# Backup each folder 1 by 1
foreach ($folder in $foldersToBackup) {
    # Get the leaf (actual folder name not path) from the folder path
    $leafName = Split-Path -Path $folder -Leaf

    # Build the command array to create the backup using robocopy
    $cmdArgs = @(
        $folder,
        "${driveLetter}:\${hostname}.backup\${timestamp}\${leafName}",
        "/MIR",     # Mirror the source directory to the destination directory.
        "/Z",       # Restartable mode. Robocopy can pick up from where it was last.
        "/XA:SH",   # Exclude system and hidden files
        "/R:3",     # Retry 3 times if a file fails
        "/W:0"      # Wait 0 seconds between retries
        )

    # Backup the files using the robocopy command
    Start-Process -FilePath robocopy -ArgumentList $cmdArgs -NoNewWindow -Wait
}

# Wait for the user to click enter to exit
Read-Host -Prompt "Backup completed. Press enter to exit"