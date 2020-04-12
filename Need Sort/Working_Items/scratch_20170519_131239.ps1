BREAK

$credential = Get-Credential
Import-Module MSOnline
Connect-MsolService -Credential $credential


Get-Content C:\temp\pshistory.txt

$users = Get-MsolUser -All | Where-Object { $_.isLicensed -eq $True }

$users
$CurrentSku = $user.Licenses.Accountskuid
$currentsku
Get-MsolUser -UserPrincipalName cmadruga@mckennacars.com
Get-MsolUser -UserPrincipalName cmadruga@mckennacars.com | fl
$cmad = Get-MsolUser -UserPrincipalName cmadruga@mckennacars.com
$cmd.licenses
$cmad.licenses
$cmad.licenses.accountskuid
$currentsku = $cmad.licenses.accountskuid
$currentsku

$newsku = New-MsolLicenseOptions -AccountSkuId $CurrentSku

$newsku

Set-MsolUserLicense -UserPrincipalName $cmad.UserPrincipalName -LicenseOptions $newsku

Get-MsolUser -all | Where-Object { $_.isLicensed -eq $True } | Set-MsolUserLicense -LicenseOptions $newsku
