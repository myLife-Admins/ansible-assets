#Check Requierments:
# - PSWindowsUpdate installed
# - PSWindowsUpdate imported
# - Custom Functions import
$LogPath = "\\fs5\temp\js\$(Get-Date -f dd-MM-yyyy)-ansible-patch-test.log"
$LocalPath = "C:\temp\ansible\wupatcher\scripts\$(Get-Date -f dd-MM-yyyy)-ansible-patch-test.log"

function Write-Log {
    param (
        [Parameter(Mandatory)]
        [string]
        $Text
    )
    Write-Host "[$(Get-Date -f "dd-MM-yyyy HH:mm:ss")] $Text"
    "[$(Get-Date -f "dd-MM-yyyy HH:mm:ss")] $Text" | Out-File -FilePath $LogPath -Append
    "[$(Get-Date -f "dd-MM-yyyy HH:mm:ss")] $Text" | Out-File -FilePath $LocalPath -Append
    
}

function Import-Modules { #Copie of Nessesary files is handel bei Ansible
    $MandatoryModules = @(
        "PSWindowsUpdate"
    )
    
    foreach ($MandatoryModule in $MandatoryModules) {
        $Check = Get-Module -Name $MandatoryModule
        if ($false -eq $Check) {
            Import-Module -Name $MandatoryModule
            Write-Log "Import-Module -Name $MandatoryModule"
        }
    }
}

function Start-MylifeWindowsUpdate {
    Write-Log "Import-Modules"
    Import-Modules
    Write-Log "Get-WindowsUpdate"
    Get-WindowsUpdate -AcceptAll -Download -Install -AutoReboot
    Write-Log "Start-Sleep -Seconds 60"
    Start-Sleep -Seconds 60
    
    $IsBusy = (Get-WUInstallerStatus).IsBusy
    Write-Log "IsBusy=$IsBusy"
    while ($IsBusy) {
        $IsBusy = (Get-WUInstallerStatus).IsBusy
        Write-Log "IsBusy=$IsBusy"
        Start-Sleep -Seconds 10
    }

    
    Write-Log "Check Reboot Get-WURebootStatus"
    if ($true) {
        Write-Log "Set Startup Event for Continue"
        $script2Path = "C:\temp\ansible\wupatcher\scripts\Continue.ps1"
        # Aufgabe im "System"-Konto erstellen und konfigurieren
        $taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -Command `"$script2Path`""
        $trigger = New-ScheduledTaskTrigger -AtStartup
        $taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -DontStopOnSessionDisconnect -DontStopOnWTSDisconnect
        Register-ScheduledTask -TaskName "WUPatcherRescan" -Action $taskAction -Trigger $trigger -Settings $taskSettings -User "NT AUTHORITY\SYSTEM"

        Write-Log "Start Reboot"
        Restart-Computer -Force
    }
}
#Setup Data:
# - Collect data
# - Create json

#Update (Every step is saved in json):
# - Get Updates
# - Start updates
# - setup after reboot event
# - reboot if nessessary

#Logs:
# - write log from json
# - clean up files
# - send report email 