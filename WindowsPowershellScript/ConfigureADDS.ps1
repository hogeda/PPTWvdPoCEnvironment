[CmdletBinding()]
param (
    [string]$domainName = 'contos.com',
    [string]$safeModeAdministratorPassword = 'SafeModeAdministratorPassword'
)
Install-WindowsFeature -Name ('AD-Domain-Services', 'GPMC') -IncludeManagementTools -Restart
Add-WindowsFeature RSAT-ADDS

[string]$domainNetBiosName = $domainName.Split('.')[0].ToUpper()
[SecureString]$safeModeAdministratorPassword = ConvertTo-SecureString -String $safeModeAdministratorPassword -AsPlainText -Force

Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "WinThreshold" `
    -DomainName $domainName `
    -DomainNetbiosName $domainNetBiosName `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -SafeModeAdministratorPassword $safeModeAdministratorPassword `
    -Force:$true