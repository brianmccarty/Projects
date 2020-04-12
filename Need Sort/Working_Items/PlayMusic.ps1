#
# shuffle-play.ps1
#
# Michael B. Smith
# http://TheEssentialExchange.com
#
# MPlayer is available from
# http://www.softpedia.com/progDownload/MPlayer-for-Windows-Full-Package-Download-55997.html
#

Param(
	$directory = "C:\Temp\Music",
	$extensions = ("*.mp3", "*.wma")
)

$files = get-childitem $directory -name:$true -include $extensions -recurse

if ($files.Length -le 0)
{
	write-host "No files meet spec"
	return
}

$random = new-object System.Random

while (1)
{
	$index = $random.Next(0, $files.Length - 1)
	$media = '"' + $directory + "\" + $files[$index] + '"'
	write-host $media
	&"C:\Temp\SMPlayerPortable\App\SMPlayer\mplayer\MPlayer.exe" "$media" | out-null
}