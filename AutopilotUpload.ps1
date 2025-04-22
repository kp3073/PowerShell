param (
    [Parameter(Mandatory = $true)]
    [string]$ClientSecret
)

# Define constants
$ClientId = "ba0012fe-032f-400a-8490-47c29dfd7c60"     # Replace with your App ID
$TenantId = "9ac44c96-980a-481b-ae23-d8f56b82c605"     # Replace with your Tenant ID

# Ensure Microsoft.Graph module is available
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.DeviceManagement)) {
    Install-Module Microsoft.Graph.DeviceManagement -Force -Scope CurrentUser
}
Import-Module Microsoft.Graph.DeviceManagement

# Authenticate using app-only (client credentials flow)
try {
    # Explicitly pass ClientSecret as a plain string
    Connect-MgGraph -ClientId $ClientId -TenantId $TenantId -ClientSecret $ClientSecret -NoWelcome
    Write-Host "✅ Authenticated to Microsoft Graph." -ForegroundColor Green
}
catch {
    Write-Error "❌ Authentication failed: $_"
    exit 1
}

# Ensure Autopilot script is available
if (-not (Get-Command Get-WindowsAutopilotInfo -ErrorAction SilentlyContinue)) {
    Install-Script -Name Get-WindowsAutopilotInfo -Force -Scope CurrentUser
}

# Run Autopilot Info Collection
try {
    Get-WindowsAutopilotInfo -Online -GroupTag "SJC"
    Write-Host "✅ Autopilot info uploaded successfully." -ForegroundColor Green
}
catch {
    Write-Error "❌ Failed to upload Autopilot info: $_"
    exit 1
}
