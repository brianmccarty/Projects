function Connect-O365 {
<#
.Synopsis
   Connects powershell to Office 365
.DESCRIPTION
   Use this to connect powershell to Office 365. You will be prompted for credentials.
   The credentials you enter will determine the client environment you connect to.
.EXAMPLE
   Connect-O365
#>
    Set-ExecutionPolicy RemoteSigned
    $Cred = Get-Credential
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic -AllowRedirection
    Import-Module (Import-PSSession $Session -Allowclobber) -Global
    Connect-MsolService -Credential $Cred
}

function Disconnect-O365 {
<#
.Synopsis
   Disconnects Office 365 powershell session.
.DESCRIPTION
   Use this to disconnect powershell from Office 365.
.EXAMPLE
   Disconnect-O365
#>
    Get-PSSession | ? {$_.computername -like “*.outlook.com”} | remove-pssession
}