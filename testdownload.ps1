function Install-ModuleCrossPlatform {
    [CmdletBinding()]
    param (
        [string]$ModuleName,
        [string]$ModuleUrl
    )

    # Determine the appropriate module path based on OS
    if ($IsWindows) {
        $modulePath = "$env:ProgramFiles\WindowsPowerShell\Modules\$ModuleName"
    }
    elseif ($IsMacOS) {
        $modulePath = Join-Path -Path $HOME -ChildPath ".local/share/powershell/Modules/$ModuleName"
    }
    else { # Linux
        $modulePath = Join-Path -Path $HOME -ChildPath ".local/share/powershell/Modules/$ModuleName"
    }

    # Create module directory if it doesn't exist
    if (-not (Test-Path -Path $modulePath)) {
        try {
            New-Item -ItemType Directory -Path $modulePath -Force -ErrorAction Stop | Out-Null
            Write-Host "✅ Created module directory at $modulePath" -ForegroundColor Green
        }
        catch {
            Write-Error "❌ Failed to create module directory: $_"
            return
        }
    }

    # Download the module
    $destinationFile = Join-Path -Path $modulePath -ChildPath "$ModuleName.psm1"
    try {
        Write-Host "📥 Downloading $ModuleName module..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $ModuleUrl -OutFile $destinationFile -ErrorAction Stop
        Write-Host "✅ Successfully installed $ModuleName module to $destinationFile" -ForegroundColor Green
        
        # Import the module to verify it works
        try {
            Import-Module $destinationFile -Force -ErrorAction Stop
            Write-Host "✔️ Module imported successfully" -ForegroundColor Green
        }
        catch {
            Write-Warning "⚠️ Module downloaded but failed to import: $_"
        }
    }
    catch {
        Write-Error "❌ Failed to download module: $_"
    }
}

# Usage example:
Install-ModuleCrossPlatform -ModuleName "MSGraph-GroupReport" `
                           -ModuleUrl "https://raw.githubusercontent.com/kp3073/PowerShell/main/MSGraph-GroupReport.psm1"
