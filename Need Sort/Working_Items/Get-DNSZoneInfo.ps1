$dnszone = Get-DnsServerZone
$dnszone

foreach($d in $dnszone) {Get-DnsServerResourceRecord -ZoneName $d.ZoneName}

$Zones = @(Get-DnsServerZone)
ForEach ($Zone in $Zones) {
    Write-Host $Zone.DistinguishedName -ForegroundColor "Yellow"
    $Zone | Get-DnsServerResourceRecord | sort Hostname
}