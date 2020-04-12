Add-PSSnapin quest.activeroles.admanagement 
$limit = (get-date).AddDays(-90).ToFileTime()
$filter = "(&(objectcategory=computer)(|(lastLogonTimestamp<=$limit)(!(lastLogonTimestamp=*))))"
Get-QADComputer -ldapFilter $filter -SizeLimit 0 | format-table name,@{l="LastLogonTimeStamp";e={if($_.lastLogonTimestamp -ne $null){[DateTime]::FromFileTime([Int64]::Parse($_.lastLogonTimestamp))}} } -autosize