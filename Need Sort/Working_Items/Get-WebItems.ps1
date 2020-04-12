cd "C:\Podcasts"
[Environment]::CurrentDirectory=(Get-Location -PSProvider FileSystem).ProviderPath
$a = ([xml](new-object net.webclient).downloadstring("http://media.grc.com/sn/"))
$a.rss.channel.item | foreach{  
    $url = New-Object System.Uri($_.enclosure.url)
    $file = $url.Segments[-1]
    $file
    if (!(test-path $file))
    {
        (New-Object System.Net.WebClient).DownloadFile($url, $file)
    }
}