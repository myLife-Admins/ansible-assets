
$LogPath = "\\fs5\temp\js\$(Get-Date -f dd-MM-yyyy)-ansible-rescan-test.log"
$LocalPath = "C:\temp\ansible\wupatcher\scripts\$(Get-Date -f dd-MM-yyyy)-ansible-rescan-test.log"

"[$(Get-Date -f "dd-MM-yyyy HH:mm:ss")] DONE" | Out-File -FilePath $LogPath -Append
"[$(Get-Date -f "dd-MM-yyyy HH:mm:ss")] DONE" | Out-File -FilePath $LocalPath -Append