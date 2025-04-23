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


