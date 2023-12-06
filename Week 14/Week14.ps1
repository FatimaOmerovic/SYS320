# Array of websites containing threat intell
$drop_urls = @(
    'https://rules.emergingthreats.net/blockrules/emerging-botcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt'
)

# Loop through the urls for the rules list
foreach ($url in $drop_urls) {
    
    # Extract the file name
    $temp = $url.split("/")

    # The last element in the array plucked off is the filename
    $file_name = $temp[-1]

    if (!(Test-Path $file_name)) {

        # Download the rules list
        Invoke-WebRequest -Uri $url -OutFile $file_name
    }
}

# This extracts IP addresses
$input_paths = @('.\compromised-ips.txt','.\emerging-botcc.rules')
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

select-string -Path $input_paths -Pattern $regex_drop | `
    ForEach-Object { $_.Matches } | `
    ForEach-Object { $_.Value } | Sort-Object | Get-Unique | `
    Out-File -FilePath "ips-bad.tmp"

# The generate rules for blocking IPs
(Get-Content -Path ".\ips-bad.tmp") | % `
{ $_ -replace "^","iptables -A INPUT -s " -replace "$", " -j DROP" } | `
Out-File -FilePath "iptables.bash"

# This creates firewall rules on the firewall type
$firewallType = 'Windows'

switch ($firewallType) {
    "Windows" {
        $windowsCommands = ()
        Get-Content -Path ".\ips-bad.tmp" | ForEach-Object {
            $windowsCommands += "New-NetFirewallRule -DisplayName 'Block $_' -Direction Inbound -Action Block -RemoteAddress $_"
        }
        $windowsCommands | Out-File -FilePath "windows-firewall.ps1"
    }
    "IPTables" {
        $iptablesCommands = ()
        Get-Content -Path ".\ips-bad.tmp" | ForEach-Object {
            $iptablesCommands += "iptables -A INPUT -s $_ -j DROP"
        }
        $iptablesCommands | Out-File -FilePath "iptables-rules.sh"
    }

}