# Define the path to 7z executable
$sevenZipPath = "C:\Program Files\7-Zip\7z.exe"  # Adjust this path if necessary

# Define the password for the archive
$password = "Mclaren_P1"  # Replace this with your password

# Today's date to archive the backup
$date = (Get-Date).ToString('MM-dd-yyyy')

# Define the output archive path and name
$archiveName = "$env:USERPROFILE\Backup\$date-backup.7z"  # Adjust output path and name as necessary

# Define the folders to include in the archive
$foldersToArchive = @(
    "$env:USERPROFILE\Desktop", 
    "$env:USERPROFILE\Documents", 
    "$env:USERPROFILE\Music", 
    "$env:USERPROFILE\Videos", 
    "$env:USERPROFILE\Pictures"
)

# Build the command to create the 7zip archive
$cmdArgs = @(
    "a",                  # 'a' means to add files to the archive
    "-p`"$password`"",        # Password protection
    $archiveName          # Output archive file name
) + $foldersToArchive     # Add the folders to the argument list

# Run the 7z command with the specified arguments
Start-Process -FilePath $sevenZipPath -ArgumentList $cmdArgs -Wait

# Wait for the user to click enter to exit
Read-Host -Prompt "Press enter to exit..."