# The path of the txt file containing the folders to restore
$foldersToRestorePath = ".\folders.txt"

# Load the folders to restore from the txt file
$foldersToRestore = Get-Content -Path $foldersToRestorePath

# Inform the user which folders are being backed up
Write-Host "`nRestoring the following folders:`n"
foreach ($folder in $foldersToRestore) {
    Write-Host $folder
}

# Ask the user for the drive they want to restore from
$driveLetter = (Read-Host -Prompt "`nPlease enter the drive letter to restore the folders from").ToUpper()

# Check if the drive is mounted at that location
if (!(Test-Path -PathType Container -Path "${driveLetter}:")) {
    # Inform the user of the error
    Write-Error "`nUnable to detect the ${driveLetter}: drive. Please ensure it is properly mounted, and then try again.`n"

    # Wait for the user to click enter to exit
    Read-Host -Prompt "`nPress enter to exit`n"
    throw
}

# Get the hostname of the machine
$hostname = (hostname);

$backupPath = "${driveLetter}:\${hostname}.backup"

# Inform the user the restore is starting
Write-Host "`nStarting restore from ${backupPath}`n"

# Restore each folder 1 by 1
foreach ($folder in $foldersToRestore) {
    # Get the leaf (actual folder name not path) from the folder path
    $leafName = Split-Path -Path $folder -Leaf

    # Build the command array to create the restore using robocopy
    $cmdArgs = @(
        "${backupPath}\${leafName}",
        $folder,
        "/MIR",     # Mirror the source directory to the destination directory.
        "/Z",       # Restartable mode. Robocopy can pick up from where it was last.
        "/XA:SH",   # Exclude system and hidden files
        "/R:3",     # Retry 3 times if a file fails
        "/W:1"      # Wait 1 seconds between retries
        )

    # Restore the files using the robocopy command
    Start-Process -FilePath robocopy -ArgumentList $cmdArgs -NoNewWindow -Wait
}

# Wait for the user to click enter to exit
Read-Host -Prompt "Restore completed. Press enter to exit"
