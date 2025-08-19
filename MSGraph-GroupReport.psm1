function Export-MSGraphGroupMembers {
    [CmdletBinding()]
    param ()

    $groupId = "60b19184-ef7f-47ce-a276-609b497baf98"

    # Ensure Microsoft.Graph is installed
    if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
        Install-Module Microsoft.Graph -Scope CurrentUser -Force
    }

    Import-Module Microsoft.Graph -Force

    # Explicitly load relevant submodules (avoids "not loaded" errors)
    $requiredModules = @(
        "Microsoft.Graph.Users",
        "Microsoft.Graph.Groups"
    )
    foreach ($m in $requiredModules) {
        if (-not (Get-Module -ListAvailable -Name $m)) {
            Import-Module $m -ErrorAction Stop
        }
    }

    # Connect with correct scopes
    Connect-MgGraph -Scopes "User.Read.All", "Group.Read.All"

    try {
        $members = Get-MgGroupMember -GroupId $groupId -All -ErrorAction Stop
    }
    catch {
        Write-Error "❌ Failed to fetch members for GroupId: $groupId. $_"
        return
    }

    if (-not $members) {
        Write-Warning "⚠️ No members found in group $groupId"
        return
    }

    $users = foreach ($member in $members) {
        # Only process user objects
        if ($member.'@odata.type' -eq "#microsoft.graph.user") {
            $user = Get-MgUser -UserId $member.Id -Property "displayName,userPrincipalName,onPremisesExtensionAttributes"
            [PSCustomObject]@{
                DisplayName       = $user.DisplayName
                UserPrincipalName = $user.UserPrincipalName
                EMC               = $user.OnPremisesExtensionAttributes.ExtensionAttribute8
            }
        }
    }

    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $dateSuffix = (Get-Date).ToString("yyyy-MM-dd")
    $fileName = "MS-Copilot-ProdApps-Teams_$dateSuffix.xlsx"
    $exportPath = Join-Path -Path $desktopPath -ChildPath $fileName

    try {
        if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
            Install-Module ImportExcel -Scope CurrentUser -Force
        }
        Import-Module ImportExcel -Force

        $users | Export-Excel -Path $exportPath -AutoSize -TableStyle Light2
        Write-Host "✅ Export complete! File saved to $exportPath" -ForegroundColor Green
    }
    catch {
        Write-Error "❌ Failed to export to Excel. $_"
    }
}

Export-ModuleMember -Function Export-MSGraphGroupMembers
