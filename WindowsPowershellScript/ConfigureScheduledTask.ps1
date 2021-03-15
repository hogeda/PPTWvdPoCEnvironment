[CmdletBinding()]
param (
    [string]$domainName = 'contos.com',
    [string]$safeModeAdministratorPassword = 'SafeModeAdministratorPassword',
    [string]$userNames = 'Enter the user names separated by ;',
    [string]$userPassword = 'Enter the user password',
    [string]$ouName = 'WVD',
    [string]$groupName = 'WVD Users'
)

# download
$uris = @('https://raw.githubusercontent.com/hogeda/PPTWvdPoCEnvironment/main/ConfigureADDS.ps1', 'https://raw.githubusercontent.com/hogeda/PPTWvdPoCEnvironment/main/CreateUserGroup.ps1')
New-Item -ItemType Directory -Path 'C:\Script'
foreach($uri in $uris){
    Invoke-WebRequest -Uri $uri -OutFile "C:\Script\$($uri.Split('/')[-1])"
}

# principal
$principal = New-ScheduledTaskPrincipal -Id 'Author' -LogonType 'ServiceAccount' -RunLevel Highest -UserId 'SYSTEM' -ProcessTokenSidType Default

# settings set
$settingsSet = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
$settingsSet.IdleSettings.IdleDuration = $null
$settingsSet.IdleSettings.WaitTimeout = $null
$settingsSet.Compatibility = 'Win8'

# action:ConfigureADDS
$action = New-ScheduledTaskAction `
    -Argument "-Command 'C:\Script\ConfigureADDS.ps1' -domainName $($domainName) -safeModeAdministratorPassword $($safeModeAdministratorPassword)" `
    -Execute 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'

# task:ConfigureADDS
$task = New-ScheduledTask -Action @($action) -Principal $principal -Settings $settingsSet
$task.Settings.IdleSettings.IdleDuration = $null
$task.Settings.IdleSettings.WaitTimeout = $null

# register:ConfigureADDS
$task | Register-ScheduledTask -TaskName 'ConfigureADDS' -TaskPath '\'

# action:ConfigureADDS
$action = New-ScheduledTaskAction `
    -Argument "-Command 'C:\Script\CreateUserGroup.ps1' -userNames $($userNames) -userPassword $($userPassword) -ouName $($ouName) -groupName $($groupName)" `
    -Execute 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'

# trigger:CreateUserGroup
$trigger = New-ScheduledTaskTrigger -AtStartup
$trigger.Delay = 'PT15M'

# task:CreateUserGroup
$task = New-ScheduledTask -Action @($action) -Principal $principal -Settings $settingsSet -Trigger $trigger
$task.Settings.IdleSettings.IdleDuration = $null
$task.Settings.IdleSettings.WaitTimeout = $null

# register:CreateUserGroup
$task | Register-ScheduledTask -TaskName 'CreateUserGroup' -TaskPath '\'

# start:ConfigureADDS
Start-ScheduledTask -TaskPath '\' -TaskName 'ConfigureADDS'