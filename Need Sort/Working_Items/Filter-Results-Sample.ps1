filter grep($keyword) { if ( ($_ | Out-String) -like "*$keyword*") { $_ } }
Get-Service | grep running
dir $env:windir | grep .exe
dir $env:windir | grep 14.07.2009
Get-Alias | grep child