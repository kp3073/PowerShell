$moduleName = "MSGraph-GroupReport"
$groupId = "60b19184-ef7f-47ce-a276-609b497baf98"
   # Replace with your constant GroupId

if ($IsWindows) {
    # Windows module path
    $moduleBase = Join-Path $env:ProgramFiles "WindowsPowerShell\Modules"
}
else {
    # macOS/Linux module path
    $moduleBase = Join-Path $HOME ".local/share/powershell/Modules"
}

$modulePath = Join-Path $moduleBase $moduleName

# Clean up old module if it exists
if (Test-Path $modulePath) {
    Remove-Item -Recurse -Force $modulePath
}

# Create module folder
New-Item -ItemType Directory -Path $modulePath -Force | Out-Null

# Download module into correct path (folder + same name as module)
$psm1File = Join-Path $modulePath "$moduleName.psm1"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/kp3073/PowerShell/main/MSGraph-GroupReport.psm1" `
    -OutFile $psm1File -UseBasicParsing

Write-Host "✅ Module installed to: $modulePath"

# Import the module
Import-Module $moduleName -Force

if (Get-Module -Name $moduleName) {
    Write-Host "✅ Module '$moduleName' successfully imported."
    Write-Host "▶ Running Export-MSGraphGroupMembers for GroupId: $groupId"

    # Run function directly
    Export-MSGraphGroupMembers -GroupId $groupId
}
else {
    Write-Host "❌ Failed to import module '$moduleName'."
}
