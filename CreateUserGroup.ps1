[CmdletBinding()]
param (
    [string]$userNames = 'Enter the user names separated by ;',
    [string]$password = 'Enter the user password',
    [string]$ouName = 'WVD',
    [string]$groupName = 'WVD Users'
)

#region create user name array
[string[]]$userNameArray = $userNames.Split(';')
[SecureString]$password = ConvertTo-SecureString -String $password -AsPlainText -Force
#endregion

#region main script
#region new ou, group
New-ADOrganizationalUnit -Name $ouName
$OU = Get-ADOrganizationalUnit -Filter * | Where-Object { $_.Name -eq $ouName }
New-ADGroup -Name $groupName -GroupScope Global -GroupCategory Security -Path $OU


$dNameADDomain = (Get-ADDomain).DistinguishedName
$domain = $dNameADDomain.Split(',').Replace('DC=','') -join '.'
## new user
foreach ($userName in $userNameArray) {
    $userPrincipalName = $userName + "@$($domain)"
    New-ADUser -Name $userName -UserPrincipalName $userPrincipalName -Path $OU -AccountPassword $password -Enabled $true
}

## add group
$ADUsers = Get-ADUser -Filter * | Where-Object { $_.Name -in $userNameArray }
$ADGroup = Get-ADGroup -Filter * | Where-Object { $_.DistinguishedName -eq "CN=$($groupName),$($OU.DistinguishedName)" }
Add-ADGroupMember -Identity $ADGroup -Members $ADUsers