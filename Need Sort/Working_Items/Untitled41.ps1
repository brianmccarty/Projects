BREAK

Get-WindowsUpdateLog
(Get-Content "WindowsUpdate.log") -notmatch "1600/12/31" | Out-File -Encoding ASCII "WindowsUpdateCleaned.log"

Add-AppxPackage -DisableDevelopmentMode -Register $Env:SystemRoot\WinStore\AppxManifest.XML