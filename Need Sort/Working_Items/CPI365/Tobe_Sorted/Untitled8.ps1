get-aduser -filter * -properties * | Where-Object targetaddress -eq $null |             Select-Object samaccountname,targetaddress,mail,proxyaddresses | Format-List
get-aduser -Filter * -Properties * | Where-Object enabled -eq $true | Select-Object displayname,samaccountname,mail,targetaddress,proxyaddresses,msexchmailboxguid,enabled,distinguishedname | Out-GridView
get-aduser brian -Properties * | Get-ADObject -Properties * | Get-Member



$pro = Get-ADUser -Identity 'brian' -Properties *
$string = $pro.msExchMailboxGuid
$bytes = [System.Text.Encoding]::Unicode.GetBytes($string)
[System.Text.Encoding]::ASCII.GetString($bytes)


