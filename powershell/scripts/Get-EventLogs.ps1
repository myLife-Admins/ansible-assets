# Get-EventLogs.ps1

# Set the start and end times
$EndTime = Get-Date
$StartTime = $EndTime.AddHours(-3)

# Define sources to exclude
$excludedSources = @("DCOM")

$logs = @()

# Get Application and System logs within the specified timeframe
$logs += Get-EventLog -LogName Application -EntryType Warning, Error -After $StartTime -Before $EndTime | Where-Object { $excludedSources -notcontains $_.Source }
$logs += Get-EventLog -LogName System -EntryType Warning, Error -After $StartTime -Before $EndTime | Where-Object { $excludedSources -notcontains $_.Source }

# Select only Source and Message properties
$result = $logs | Select-Object -Property Source, Message | ConvertTo-Json -Depth 3
Write-Output $result
