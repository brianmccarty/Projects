$strFilter = "computer"

$objDomain = New-Object System.DirectoryServices.DirectoryEntry

$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objDomain
$objSearcher.SearchScope = "Subtree"
$objSearcher.PageSize = 1000

$objSearcher.Filter = "(objectCategory=$strFilter)"

$colResults = $objSearcher.FindAll()

foreach ($i in $colResults)
{
	$objComputer = $i.GetDirectoryEntry()
	if (Test-Connection -BufferSize 32 -Count 1 -ComputerName $i -Quiet)
	{
		(Get-WmiObject -Class Win32_Product -Filter "Name='Symantec Endpoint Protection'" -ComputerName $objComputer.Name).Uninstall()
	}
	else
	{
		$offline = $i | Out-File -filepath C:\process.csv -Append
	}
}
C:\Users\bmccarty\OneDrive\00-Source\Training\2-powershell-building-client-troubleshooting-tool-m2\__MACOSX\Demos copy\VNC\


Get-ChildItem -Path C:\Users\bmccarty -Recurse -Directory -filter "__MACOSX"

Get-ChildItem -Path c:\ -Recurse -filter "esrv.exe"

get-childitem -Path "C:\Users\bmccarty\Google Drive\Needs Sorting\Microsoft_OneDrive\Aidan" | Rename-Item -NewName { $_.Name -replace "..png", ".png" }

Get-ChildItem -Path c: -Recurse -Filter "rdp*"