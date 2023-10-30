# Task: Grab the network adapter information using the WMI class
# Get the IP address, default gateway, and the DNS servers.
# BONUS: Get the DHCP server.
# Running your code using a screen recorder.

# Task 1: 
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | Select-Object -Property DHCPServer, DNSServerSearchOrder

# Task 2:
Get-Process | Export-Csv -Path "C:\Users\champuser\Desktop\ProcessesRunning.csv" -NoTypeInformation
Get-Service | Where-Object { $_.Status -eq "Running" } | Export-Csv -Path "C:\Users\champuser\Desktop\ServicesRunning.csv" -NoTypeInformation

# Task 3:
Start-Process -Name "calc"
Get-Process -Name "calc*" | Stop-Process -Force
Write-Output "You just killed the calculator :("