cls
# Login to a remote SSH server
#SSHSession -ComputerName '192.168.0.118' -Credential (Get-Credential champuser)

# This is supposed to upload a file to remote server using SCP
Set-SCPFile -ComputerName '192.168.0.118' -Credential (Get-Credential champuser) `
    -RemotePath '/home/champuser' -LocalFile 'C:\Users\champuser\Downloads\yourmom.txt'

# This calculates hash value for the local file
$file = Get-FileHash "C:\Users\champuser\Downloads\yourmom.txt"

# This retrieves the file by SCP to check if it's there
Get-SCPFile -ComputerName '192.168.0.118' -Credential (Get-Credential champuser) `
    -RemoteFile '/champuser/Downloads/yourmom.txt' -LocalFile 'C:\Users\champuser\Downloads\yourmom.txt'

# This calculates hash value for the retreieved file
$check = Get-FileHash 'C:\Users\champuser\Downloads\yourmom.txt'

# Output of the hash values
Write-Output $file
Write-Output $check
