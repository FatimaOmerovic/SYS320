# Storyline: Review the Security Event Log

# Directory to save files:

$myDir = "C:\Users\champuser\Desktop\"

# List all the available Windows Event Logs
Get-EventLog -list

# Create a prompt to allow user to specify a keyword or phrase to search for, select the Log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above"
$searchKeyword = Read-Host -Prompt "Enter a keyword or phrase to search for in the selected log"

# Print the results for the log
Get-EventLog -Logname $readLog | where {$_.Message -ilike "*$searchKeyword*" } | export-csv -NoTypeInfo -Path "$myDir\securityLogs.csv"

# Task: Create a prompt that allows the user to specify a keyword or phrase to search on.
# Find a string from your event logs to search on
# did it above woooo

