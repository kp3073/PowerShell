param (
    [Parameter(Mandatory = $true)]
    [string]$ClientSecret
)

# Define your Azure AD app credentials here
$ClientId = "YOUR-CLIENT-ID"     # Replace this
$TenantId = "YOUR-TENANT-ID"     # Replace this

# Install required module if missing
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.DeviceManagement)) {
    Install-Module Microsoft.Graph.DeviceManagement -Force -Scope CurrentUser
}
Import-Module Microsoft.Graph.DeviceManagement

# Authenticate using client secret
try {
    Connect-MgGraph -ClientId $ClientId -TenantId $TenantId -ClientSecret $ClientSecret
    Write-Host "✅ Authenticated to Microsoft Graph." -ForegroundColor Green
}
catch {
    Write-Error "❌ Authentication failed: $_"
    exit
}

# Install required Autopilot script if missing
if (-not (Get-Command Get-WindowsAutopilotInfo -ErrorAction SilentlyContinue)) {
    Install-Script -Name Get-WindowsAutopilotInfo -Force -Scope CurrentUser
}

# Run Autopilot upload
try {
    Get-WindowsAutopilotInfo -Online -GroupTag "SJC"
    Write-Host "✅ Autopilot info uploaded successfully." -ForegroundColor Green
}
catch {
    Write-Error "❌ Failed to upload Autopilot info: $_"
}
