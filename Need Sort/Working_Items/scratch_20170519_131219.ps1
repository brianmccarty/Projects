#############################################################################

$SourceFile = "C:\Temp\File.txt"
$DestinationFile = "C:\Temp\NonexistentDirectory\File.txt"


foreach ($file in $rootfolder)
{
	$file.fullname
	Write-Host	"$roots\$file"
	Move-Item -Path $file.FullName -Destination "$roots\$file"
}


foreach ($file in $rootfolder)
{
	If (Test-Path "$roots\$file")
	{
		$i = 0
		While (Test-Path "$filenew")
		{
			$i += 1
			$filebase = $file.basename
			$fileext = $file.extension
			$filenew = "$roots\$filebase_$i$fileext"
		}
	}
	#Move-Item -Path $file.FullName -Destination "$filenew"
}
















Else
{
	New-Item -ItemType File -Path $DestinationFile -Force
}

Copy-Item -Path $SourceFile -Destination $DestinationFile -Force

#############################################################################