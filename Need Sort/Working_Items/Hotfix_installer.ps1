$domainname = Get-Content env:userdnsdomain

$wustart = Get-Service -Name wuauserv | Select starttype
If ($wustart.StartType -eq "Disabled") {Set-Service -Name wuauserv -StartupType Manual}
Start-Service -Name wuauserv

Copy-Item -Path \\$domainname\netlogon\Hotfixes -Destination C:\ -Recurse

Get-Item -Path C:\hotfixes\* | foreach {WUSA ""$_.FullName /quiet /norestart"";while(Get-Process wusa){Write-Host "Installing $_.Name"}}
