Get-ADDomainController -Filter * |  foreach {Get-DnsServerForwarder -Computername $_.name}
Get-ADDomainController -Filter * |  foreach {Add-DnsServerForwarder -Computername $_.name -IPAddress 208.67.222.222,208.67.220.220}
Get-ADDomainController -Filter * |  foreach {Set-DnsServerForwarder -Computername $_.name -IPAddress 208.67.222.222,208.67.220.220}