$desktopFolderContents = "C:\Users\ridvikpal\Desktop\"
$documentsFolderContents = "C:\Users\ridvikpal\Documents\"
$picturesFolderContents = "C:\Users\ridvikpal\Pictures\"
$musicFolderContents = "C:\Users\ridvikpal\Music\"
$videosFolderContents = "C:\Users\ridvikpal\Videos\"

$desktopBackupFolder = "D:\Desktop"
$documentsBackupFolder = "D:\Documents"
$photosBackupFolder = "D:\Pictures"
$musicBackupFolder = "D:\Music"
$videosBackupFolder = "D:\Videos"

Write-Host "Starting backup to D: (Backup) drive`n"

# Backup the desktop folder
robocopy $desktopFolderContents $desktopBackupFolder /MIR /Z /XA:SH /R:3 /W:0
# Backup the documents folder
robocopy $documentsFolderContents $documentsBackupFolder /MIR /Z /XA:SH /R:3 /W:0
# Backup the photos folder
robocopy $picturesFolderContents $photosBackupFolder /MIR /Z /XA:SH /R:3 /W:0
# Backup the music folder
robocopy $musicFolderContents $musicBackupFolder /MIR /Z /XA:SH /R:3 /W:0
# Backup the videos folder
robocopy $videosFolderContents $videosBackupFolder /MIR /Z /XA:SH /R:3 /W:0

Write-Host "`nBackup completed."