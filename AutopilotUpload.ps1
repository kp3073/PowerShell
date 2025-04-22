param (
    [Parameter(Mandatory = $true)]
    [string]$ClientSecret
)

# Define your Azure AD app credentials here
$ClientId = "ba0012fe-032f-400a-8490-47c29dfd7c60"     # Replace this
$TenantId = "9ac44c96-980a-481b-ae23-d8f56b82c605"     # Replace this

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
