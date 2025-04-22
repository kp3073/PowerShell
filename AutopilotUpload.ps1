<#
.SYNOPSIS
Uploads device info to Intune Autopilot using app-only authentication.
.PARAMETER ClientSecret
Client secret passed at runtime.
.EXAMPLE
.\AutopilotUpload.ps1 -ClientSecret "your-secret"
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$ClientSecret
)

# === Configurable values ===
$clientId  = "ba0012fe-032f-400a-8490-47c29dfd7c60"
$tenantId  = "9ac44c96-980a-481b-ae23-d8f56b82c605"
$groupTag  = "SJC"

# === Ensure modules ===
$modules = @("Microsoft.Graph.Authentication", "Microsoft.Graph.DeviceManagement", "Get-WindowsAutopilotInfo")
foreach ($module in $modules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Install-Module -Name $module -Force -Scope CurrentUser
    }
}

# === Auth with client secret passed via parameter ===
$secureSecret = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force

try {
    Connect-MgGraph -ClientId $clientId -TenantId $tenantId -ClientSecret $secureSecret -ErrorAction Stop
    Write-Host "✅ Connected to Microsoft Graph." -ForegroundColor Green
}
catch {
    Write-Error "❌ Authentication failed: $_"
    exit 1
}

Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force

try {
    Get-WindowsAutopilotInfo -GroupTag $groupTag -Online
    Write-Host "✅ Device uploaded to Autopilot with GroupTag '$groupTag'" -ForegroundColor Green
}
catch {
    Write-Error "❌ Failed to upload to Autopilot: $_"
    exit 1
}
