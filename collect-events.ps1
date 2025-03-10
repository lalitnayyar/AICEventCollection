param (
    [string]$folderPath = "C:\troubleshoot\P3\dummyfiles",
    [string]$newFolderPath = "C:\troubleshoot\P3\$($env:COMPUTERNAME)"
)

# Define the output file paths
$eventsOutputFile = "events.csv"
$serverInfoOutputFile = "server-info.csv"
$servicePacksOutputFile = "service-packs.csv"
$rebootInfoOutputFile = "reboot-info.csv"
$folderFilesOutputFile = "folder-files.csv"

# Get the hostname
$hostname = $env:COMPUTERNAME

# Create a new folder with the hostname
New-Item -ItemType Directory -Path $newFolderPath -Force

# Get all event logs
$eventLogs = Get-EventLog -List

# Initialize an empty array to store events
$allEvents = @()

# Define the date range for the last 15 days
$startDate = (Get-Date).AddDays(-15)

# Loop through each event log and collect events from the last 15 days
foreach ($log in $eventLogs) {
    Write-Host "Collecting events from log: $($log.Log)"
    $events = Get-EventLog -LogName $log.Log | Where-Object { $_.TimeGenerated -ge $startDate }
    $allEvents += $events
}

# Export the collected events to a CSV file
$allEvents | Export-Csv -Path "$newFolderPath\$eventsOutputFile" -NoTypeInformation

Write-Host "Events from the last 15 days have been collected and exported to $newFolderPath\$eventsOutputFile"

# Collect Windows Server information
$serverInfo = Get-WmiObject -Class Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber, OSArchitecture, CSName

# Collect hostname, FQDN, and IP address
$fqdn = [System.Net.Dns]::GetHostByName($hostname).HostName
$ipAddresses = [System.Net.Dns]::GetHostAddresses($fqdn) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -ExpandProperty IPAddressToString

# Create a custom object to store server information
$serverInfoObject = [PSCustomObject]@{
    Hostname       = $hostname
    FQDN           = $fqdn
    IPAddress      = $ipAddresses -join ", "
    Caption        = $serverInfo.Caption
    Version        = $serverInfo.Version
    BuildNumber    = $serverInfo.BuildNumber
    OSArchitecture = $serverInfo.OSArchitecture
    CSName         = $serverInfo.CSName
}

# Export the server information to a CSV file
$serverInfoObject | Export-Csv -Path "$newFolderPath\$serverInfoOutputFile" -NoTypeInformation

Write-Host "Windows Server information has been collected and exported to $newFolderPath\$serverInfoOutputFile"

# Collect Windows Server service packs
$servicePacks = Get-WmiObject -Class Win32_QuickFixEngineering | Select-Object Description, HotFixID, InstalledOn

# Export the service packs information to a CSV file
$servicePacks | Export-Csv -Path "$newFolderPath\$servicePacksOutputFile" -NoTypeInformation

Write-Host "Windows Server service packs have been collected and exported to $newFolderPath\$servicePacksOutputFile"

# Collect system reboot instances
$rebootEvents = Get-EventLog -LogName System -Source "EventLog" -After $startDate | Where-Object { $_.EventID -eq 6005 -or $_.EventID -eq 6006 } | Select-Object EventID, TimeGenerated, EntryType, Message

# Export the reboot instances to a CSV file
$rebootEvents | Export-Csv -Path "$newFolderPath\$rebootInfoOutputFile" -NoTypeInformation

Write-Host "System reboot instances have been collected and exported to $newFolderPath\$rebootInfoOutputFile"

# Collect files from the specified folder with the current date
$currentDate = Get-Date -Format "yyyy-MM-dd"
$folderFiles = Get-ChildItem -Path $folderPath | Where-Object { $_.LastWriteTime -ge (Get-Date).Date } | Select-Object Name, LastWriteTime, Length

# Export the folder files information to a CSV file
$folderFiles | Export-Csv -Path "$newFolderPath\$folderFilesOutputFile" -NoTypeInformation

Write-Host "Files from the folder have been collected and exported to $newFolderPath\$folderFilesOutputFile"

# Define the zip file name with the current date and time
$zipFileName = "$(Get-Date -Format 'yyyyMMdd-HHmmss')-logs.zip"
$zipFilePath = "$newFolderPath\$zipFileName"

# Compress the collected files into a zip file
Compress-Archive -Path "$folderPath\*" -DestinationPath $zipFilePath

Write-Host "Files have been compressed into $zipFilePath"