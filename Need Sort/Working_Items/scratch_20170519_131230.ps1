(Invoke-WebRequest -uri "https://live.sysinternals.com").links.href | foreach { Invoke-WebRequest -uri "https://live.sysinternals.com$_" -OutFile "C:\Sysinternals$_" }

Get-NetAdapter

$credential = Get-Credential
Import-Module MSOnline
Connect-MsolService -Credential $credential

Remove-MsolUser -UserPrincipalName jeri.martinez@mckennacars.com -RemoveFromRecycleBin

get-msoluser -all | where immutableid -ne $null | Set-MsolUserLicense -AddLicenses "reseller-account:STANDARDPACK"


get-msoluser -all | where immutableid -ne $null | Set-MsolUser -UsageLocation US

