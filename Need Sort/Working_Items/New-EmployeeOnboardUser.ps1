param($FirstName,$MiddleInitial,$LastName,$Location = 'OU=Corporate Users',$Title)

$DefaultPassword = 'p@$$w0rd12'
$DomainDN = (Get-ADDomain).DistinguishedName
$DefaultGroup = 'Gigantic Corporation Inter-Intra Synergy Group'

### Figure out what the username should be
$Username = "$(FirstName.SubString(0,1))$LastName"
$EAPrefBefore = $ErrorActionPreference
$ErrorActionPreference = 'SilentyContinue'
if (Get-ADUser $Username) {
    $USername = "$($FirstName.SubString(0,1))$MiddleInitial$LastName"
    if (Get-ADUser $Username) {
        Write-Warning "No Acceptable Username schema could be created"
        return
    }
}

## Create the user account
$ErrorActionPreference = $EAPrefBefore
$NewUserParams = @{
    'UserPrincipalName' = $Username
    'Name' = $UserName
    'GivenName' = $FirstName
    'Surname' = $LastName
    'Title' = $Title
    'SamAccountName' = $Username
    'AccountPassword' = (ConvertTo-SecureString $DefautlPassword -AsPlainText -Force)
    'Enabled' = $True
    'Initials' = $MiddleInitial
    'Path' = "$Location,$DomainDn"
    'ChangePasswordAtLogon' = $True
}

New-AdUser @NewUserParams

## Add the user account to the company standard group
Add-ADGroupMember -Identity $DefaultGroup -Members $Username