
<#
.SYNOPSIS
    Initiates a full reset of the Windows device (Remove Everything).

.DESCRIPTION
    This script opens the Windows reset interface where the user can choose to remove all files and reinstall Windows.

.NOTES
    Run this script as Administrator. It will not work in standard PowerShell sessions.
#>

# Ensure the script is run as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "⚠️ Please run this script as Administrator!"
    pause
    exit
}

Write-Host "🚨 WARNING: This will reset your PC to factory settings and remove all personal files!" -ForegroundColor Red
Write-Host "Are you sure you want to continue? Press Ctrl+C to cancel." -ForegroundColor Yellow
pause

try {
    Start-Process "systemreset" -ArgumentList "-factoryreset" -Wait
}
catch {
    Write-Error "❌ Failed to start system reset. Make sure you're running as Administrator."
}
