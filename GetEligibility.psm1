if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
    Write-Output "ImportExcel module not found. Installing..."
    Install-Module -Name ImportExcel -Scope CurrentUser -Force
}
# Import the required module
Import-Module ImportExcel

# Define the path to your Excel file
$excelFilePath = "\\DEVITSD01\PSAlign\ALIGN INVENTORY.xlsx"
# "\\tor-75r5pz3\SharedFiles\ALIGN INVENTORY.xlsx"

# Function to get the eligibility date for a given personal name

function Get-eligibilityDate {
    param (
        [string]$employeeName
    )

    # Read the Wireless Inventory sheet
    $Inventory = Import-Excel -Path $excelFilePath -WorksheetName "Wireless Inventory"

    # Filter the data to find rows with the given personal name and device model
    $rows = $Inventory | Where-Object { 
        $_.Personnel -like "*$employeeName*" -and ($_. 'Device Model' -like "Apple iPhone *" -or $_.'Device Model' -like "Samsung *")
    }

    if ($rows) {
        foreach ($row in $rows) {
            # Create a PSCustomObject with the eligibility date and device model
            [PSCustomObject]@{
                Name            = $row.'Personnel'
                DeviceModel     = $row.'Device Model'
                EligibilityDate = ([datetime]$row.'Upgrade eligibility date').ToString("dd MMMM yyyy")
            }
        }
    } else {
        Write-Output "Employee name not found in the Wireless Inventory sheet."
    }
}
