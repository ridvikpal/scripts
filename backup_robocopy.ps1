# Define the folders to backup
$foldersToArchive = @(
    "$env:USERPROFILE\Desktop", 
    "$env:USERPROFILE\Documents", 
    "$env:USERPROFILE\Music", 
    "$env:USERPROFILE\Videos", 
    "$env:USERPROFILE\Pictures"
    "$env:USERPROFILE\Downloads"
)

# Ask the user for the external drive they want to backup the archive ot
$driveLetter = (Read-Host -Prompt "Please enter the external drive letter to backup folders to (make sure the drive is mounted)").ToUpper()

# Check if the external drive is mounted at that location
if (!(Test-Path -PathType Container -Path "${driveLetter}:")) {
    throw "Unable to detect the ${driveLetter}: drive. Please ensure it is properly mounted."
}

Write-Host "Backing up the following folders:`n"

foreach ($folder in $foldersToArchive) {
    Write-Host $folder
}

Write-Host "`nStarting backup to D: (Backup) drive`n"

foreach ($folder in $foldersToArchive) {
    # Get the leaf (actual folder name not path) from the folder path
    $leafName = Split-Path -Path $folder -Leaf

    # Build the command to create the backup using robocopy
    $cmdArgs = @(
        $folder,
        "${driveLetter}:\$leafName",
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
Read-Host -Prompt "Backup completed. Press enter to exit..."