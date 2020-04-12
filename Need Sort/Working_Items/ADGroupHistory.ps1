Import-Module ActiveDirectory

$username = "braden"
$userobj  = Get-ADUser $username

Get-ADUser $userobj.DistinguishedName -Properties memberOf |
 Select-Object -ExpandProperty memberOf |
 ForEach-Object {
    Get-ADReplicationAttributeMetadata $_ -Server CPI-DC02 -ShowAllLinkedValues | 
      Where-Object {$_.AttributeName -eq 'member' -and 
      $_.AttributeValue -eq $userobj.DistinguishedName} |
      Select-Object FirstOriginatingCreateTime, Object, AttributeValue
    } | Sort-Object FirstOriginatingCreateTime -Descending | Out-GridView