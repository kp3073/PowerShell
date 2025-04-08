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
function Get-EligibilityDateTest {
    param (
        [string]$employeeName
    )

    # Check if the file exists
    if (-Not (Test-Path $excelFilePath)) {
        Write-Error "Excel file not found at path: $excelFilePath"
        return
    }

    # Read the Wireless Inventory sheet
    $Inventory = Import-Excel -Path $excelFilePath -WorksheetName "Wireless Inventory"

    # Filter the data to find rows with the given personal name and device model
    $rows = $Inventory | Where-Object { 
        $_.Personnel -like "*$employeeName*" -and ($_. 'Device Model' -match "Apple iPhone|Samsung")
    }

    if ($rows) {
        $rows | ForEach-Object {
            [PSCustomObject]@{
                'Name'            = $_.'Personnel'
                'DeviceModel'     = $_.'Device Model'
                'EligibilityDate' = $_.'Upgrade eligibility date'
            }
        } | Format-Table -AutoSize
    } else {
        Write-Output "No records found for '$employeeName' in the Wireless Inventory sheet."
    }
}
