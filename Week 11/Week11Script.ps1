# Declaring and using function to gather running processes
function Get-RunningProcesses {
    Get-Process | Select-Object ProcessName, Path | Export-Csv -Path $PathToSave\processes.csv -NoTypeInformation
}

# Declaring and using function to get registered services and their paths using WMI
function Get-Services {
    Get-WmiObject Win32_Service | Select-Object DisplayName, PathName | Export-Csv -Path $PathToSave\services.csv -NoTypeInformation
}

# Declaring and using function to get information about Tcp network sockets
function Get-TcpSockets {
    Get-NetTCPConnection | Export-Csv -Path $PathToSave\tcpSockets.csv -NoTypeInformation
}

# Declaring and using function to get user account information using Wmi
function Get-UserAccounts {
    Get-WmiObject Win32_UserAccount | Select-Object Name, FullName | Export-Csv -Path $PathToSave\userAccounts.csv -NoTypeInformation
}

# Declaring and using function to collect network adapter config information
function Get-NetworkAdapterConfiguration {
    Get-WmiObject Win32_NetworkAdapterConfiguration | Export-Csv -Path $PathToSave\networkAdapterConfiguration.csv -NoTypeInformation
}

# Declaring and using function to save four artifacts w/ powershell cmdlets
function Four-OtherArtifacts {
    # The four cmdlet artifacts that that would be useful in an incident
    Get-EventLog -LogName Application -EntryType Error | Export-Csv -Path $PathToSave\eventLogs.csv -NoTypeInformation
    # The Application EventLog gives errors with install applications that can identify anomalies during an investigation

    Get-EventLog -LogName Security -EntryType FailureAudit | Export-Csv -Path "$PathToSave\securityFailures.csv" -NoTypeInformation
    # The Security EventLog would be the most important because it gives info such as unsuccessful logons and other policy violations

    Get-NetFirewallRule | Export-Csv -Path "$PathToSave\firewallRules.csv" -NoTypeInformation
    # The NetFirewallRule gives good information regarding allowed/blocked traffic and any changes to network config

    Get-EventLog -LogName System -EntryType Error | Export-Csv -Path $PathToSave\systemErrors.csv -NoTypeInformation
    # The System EventLog I thought would be important as well, due to it being the system itself. 
}

# This prompts the user to specify where they want to save the results
$PathToSave = Read-Host "Specify the location to save the results"

# This calls the functions
Get-RunningProcesses
Get-Services
Get-TcpSockets
Get-UserAccounts
Get-NetworkAdapterConfiguration
Four-OtherArtifacts

# This creates the file hashes and store checksums as SHA1
Get-ChildItem -Path $PathToSave | ForEach-Object {
    $hash = Get-FileHash $_.FullName -Algorithm SHA1
    "$($hash.Hash)  $($_.Name)" | Out-File -Append "$PathToSave\checksums.txt"
}

# This compress' the results directory
Compress-Archive -Path $PathToSave -DestinationPath "$PathToSave\Thezippedresults.zip"

# This generates a checksum for the compressed file
$zipChecksum = Get-FileHash "$PathToSave\Thezippedresults.zip" -Algorithm SHA1
$zipChecksum | Out-File "$PathToSave\results_checksum.txt"

Write-Host "Script was completed successfully!!!! `nCheck the following files in the output directory:`n - processes.csv`n - services.csv`n - tcpSockets.csv`n - userAccounts.csv`n - networkAdapterConfiguration.csv`n - eventLogs.csv`n - securityFailures.csv`n - firewallRules.csv`n - systemErrors.csv`n - checksums.txt`n - Thezippedresults.zip`n - results_checksum.txt"
