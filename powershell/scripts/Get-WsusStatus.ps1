# Get-WsusStatus.ps1
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer("WSUS2.gutingia.local", $False, 8530)
$computers = $wsus.GetComputerTargetGroups() | ForEach-Object {
    $_.GetComputerTargets()
}

$result = @()
foreach ($computer in $computers) {
    $status = $computer.GetUpdateInstallationInfoPerUpdate() | ForEach-Object {
        [pscustomobject]@{
            ComputerName = $computer.FullDomainName
            UpdateTitle  = $_.Update.Title
            UpdateState  = $_.UpdateInstallationState.ToString()
        }
    }
    $result += $status
}

$result | ConvertTo-Json
$result