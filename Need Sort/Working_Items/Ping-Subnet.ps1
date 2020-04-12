Function Ping-Subnet
{
	[cmdletbinding()]
	Param (
		[string]$Subnet = "192.168.7.",
		[int]$Start = 1,
		[int]$End = 254
	)
	
	Write-Verbose "Pinging $subnet from $start to $end"
	#contruct the ip address from the numbers between start and end
	$start .. $end | Where-Object {
		test-connection -computername "$subnet$_" -count 1 -quiet
	} | ForEach-Object {
		"$subnet$_"
	}
} #end Ping-Subnet function