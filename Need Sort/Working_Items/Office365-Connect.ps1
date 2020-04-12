Set-ExecutionPolicy RemoteSigned
$Cred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange-ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic -AllowRedirection
Import-PSSession $Session
Connect-MSolService -Credential $Cred