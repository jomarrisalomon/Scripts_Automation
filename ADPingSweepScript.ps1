# Function to check if a computer is online
function Test-ComputerOnline {
    param(
        [string]$ComputerName
    )
    $pingResult = Test-Connection -ComputerName $ComputerName -Count 1 -ErrorAction SilentlyContinue
    return [PSCustomObject]@{
        ComputerName = $ComputerName
        IPAddress = if ($pingResult) { $pingResult.IPV4Address.IPAddressToString } else { "N/A" }
        Online = [bool]($pingResult -ne $null)
    }
}

# Read a list of enabled computers from Active Directory (you can replace this with your own method)
$enabledComputers = Get-ADComputer -Filter {Enabled -eq $true} | Select-Object -ExpandProperty Name

# Initialize an array to store ping results
$pingResults = @()

# Loop through each enabled computer and test its online status
foreach ($computer in $enabledComputers) {
    $pingResults += Test-ComputerOnline -ComputerName $computer
}

# Display ping results in a formatted table
$pingResults | Format-Table -AutoSize
