# PowerShell

vim ./install.ps1

#give permission
chmod +x install.ps1

#execute script
./install.ps1

#verify Module is installed 
Get-Module -Name MSGraph-GroupReport -ListAvailable

#import module 
Import-Module MSGraph-GroupReport -Force

#RUN
Export-MSGraphGroupMembers


##
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/kp3073/PowerShell/main/AutopilotUpload.ps1" -OutFile "$env:TEMP\AutopilotUpload.ps1"; PowerShell -ExecutionPolicy Bypass -File "$env:TEMP\AutopilotUpload.ps1" -ClientSecret "your-client-secret-here"
