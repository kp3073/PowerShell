function Export-MSGraphGroupMembers {
    [CmdletBinding()]
    param ()

    $groupId = "60b19184-ef7f-47ce-a276-609b497baf98"

    if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
        Install-Module Microsoft.Graph -Scope CurrentUser -Force
    }
    Import-Module Microsoft.Graph

    Connect-MgGraph -Scopes "User.Read.All", "Group.Read.All"

    try {
        $members = Get-MgGroupMember -GroupId $groupId -All
    }
    catch {
        Write-Error "❌ Failed to fetch members for GroupId: $groupId"
        return
    }

    $users = @()
    foreach ($member in $members) {
        $user = Get-MgUser -UserId $member.Id -Property "displayName,UserPrincipalName,onPremisesExtensionAttributes"
        $users += [PSCustomObject]@{
            DisplayName       = $user.DisplayName
            UserPrincipalName = $user.UserPrincipalName
            EMC               = $user.OnPremisesExtensionAttributes.ExtensionAttribute8
        }
    }

    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $dateSuffix = (Get-Date).ToString("yyyy-MM-dd")
    $fileName = "MS-Copilot-ProdApps-Teams_$dateSuffix.xlsx"
    $exportPath = Join-Path -Path $desktopPath -ChildPath $fileName

    try {
        $users | Export-Excel -Path $exportPath -AutoSize -TableStyle Light2
        Write-Host "✅ Export complete! File saved to $exportPath" -ForegroundColor Green
    }
    catch {
        Write-Error "❌ Failed to export to Excel. Check if the file is already open or path is valid."
    }
}

Export-ModuleMember -Function Export-MSGraphGroupMembers
