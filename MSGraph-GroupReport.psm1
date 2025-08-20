    
# install-graph-report.ps1
$moduleName = "MSGraph-GroupReport"
$groupId = "60b19184-ef7f-47ce-a276-609b497baf98"
   # 🔹 Replace this with your constant GroupId

if ($IsWindows) {
    # Windows
    $modulePath = Join-Path $env:ProgramFiles "WindowsPowerShell\Modules\$moduleName"
}
else {
    # macOS/Linux
    $modulePath = Join-Path $HOME ".local/share/powershell/Modules/$moduleName"
}

# Ensure clean slate (delete old version if exists)
if (Test-Path $modulePath) {
    Remove-Item -Recurse -Force $modulePath
}

# Create module folder
New-Item -ItemType Directory -Path $modulePath -Force | Out-Null

# Download module from GitHub
$psm1File = Join-Path $modulePath "$moduleName.psm1"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/kp3073/PowerShell/main/MSGraph-GroupReport.psm1" -OutFile $psm1File -UseBasicParsing

Write-Host "✅ Module installed to: $modulePath"

# Import module
Import-Module $moduleName -Force

if (Get-Module -Name $moduleName) {
    Write-Host "✅ Module '$moduleName' successfully imported."
    
    # 🔹 Run the report automatically with the constant GroupId
    Write-Host "▶ Running Export-MSGraphGroupMembers for GroupId: $groupId"
    Export-MSGraphGroupMembers -GroupId $groupId
} 
else {
    Write-Host "❌ Failed to import module '$moduleName'."
}
