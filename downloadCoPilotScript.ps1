$moduleName = "CoPilotGroupMembers"
$modulePath = "$env:ProgramFiles\WindowsPowerShell\Modules\$moduleName"
New-Item -ItemType Directory -Path $modulePath -Force
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/kp3073/PowerShell/main/CoPilotGroupMembers.psm1" -OutFile "$modulePath\$moduleName.psm1"
