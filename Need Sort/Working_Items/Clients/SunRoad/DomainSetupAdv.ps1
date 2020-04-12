BREAk

Connect-MSOLService
$srdomains = Get-Content 'C:\Users\bmccarty\OneDrive - CPI Solutions\clients\Sunroad\sunroaddomains.csv'

foreach ($srdomain in $srdomains)
	{
	New-MsolDomain –Authentication Managed –Name $srdomain
}  


$srverify = Get-MsolDomain | Where-Object {$_.status -ne "Verified"} | Select-Object name

$srverify

foreach ($srverifyc in $srverify)
    {
    Get-MsolDomainVerificationDns -DomainName $srverifyc.Name -mode DnsTxtRecord
}

foreach ($srverifyc in $srverify)
    {
    Get-MsolDomainVerificationDns -DomainName $srverifyc.Name -mode DnsTxtRecord
}