get-aduser -filter * -properties * | where targetaddress -eq $null |             select samaccountname,targetaddress,mail,proxyaddresses | fl
get-aduser -Filter * -Properties * | where enabled -eq $true | select displayname,samaccountname,mail,targetaddress,proxyaddresses,msexchmailboxguid,enabled,distinguishedname | ogv
get-aduser brian -Properties * | Get-ADObject -Properties * | gm



$pro = Get-ADUser -Identity 'brian' -Properties *
$string = $pro.msExchMailboxGuid
$bytes = [System.Text.Encoding]::Unicode.GetBytes($string)
[System.Text.Encoding]::ASCII.GetString($bytes)


