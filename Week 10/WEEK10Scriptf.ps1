# Defining the options to choose from
$userOptions = @('all', 'stopped', 'running', 'quit')

while ($true) {
    # First user prompt to get user input
    $userInput = Read-Host "Type 'all' to view all services, 'stopped' to view stopped services, 'running' to view running services, or 'quit' to exit"

    # Checks to see if user input is valid
    if ($userOptions -contains $userInput) {
        # Handle 'quit' option
        if ($userInput -eq 'quit') {
            Write-Host "Exiting the program."
            break
        }
        
        # List services based on user input
        if ($userInput -eq 'all') {
            Get-Service | Select-Object DisplayName, Status
        } elseif ($userInput -eq 'stopped') {
            Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Select-Object DisplayName, Status
        } elseif ($userInput -eq 'running') {
            Get-Service | Where-Object { $_.Status -eq 'Running' } | Select-Object DisplayName, Status
        }
    } else {
        # Invalid input, it prompts an error message
        Write-Host "Invalid input! Please type 'all', 'stopped', 'running', or 'quit'."
    }
}