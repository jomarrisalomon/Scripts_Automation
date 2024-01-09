# Get a list of all computers in the Active Directory domain
$computers = Get-ADComputer -Filter {Enabled -eq $true}

# Create an empty array to store the results
$results = @()

# Loop through each computer and retrieve Windows update information
foreach ($computer in $computers) {
    $computerName = $computer.Name
    $hotfixes = Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $computerName

    foreach ($hotfix in $hotfixes) {
        $hotfixID = $hotfix.HotFixID
        $description = $hotfix.Description
        $InstalledOn = $hotfix.InstalledOn

        # Add the information to the results array
        $results += [PSCustomObject]@{
            ComputerName = $computerName
            HotfixID = $hotfixID
            Description = $description
            InstallationDate = $InstalledOn
        }
    }
}

# Display the results in a formatted table
$results | Format-Table -AutoSize

# You can also export the results to a CSV file if you'd like
# $results | Export-Csv -Path "WindowsUpdates.csv" -NoTypeInformation
