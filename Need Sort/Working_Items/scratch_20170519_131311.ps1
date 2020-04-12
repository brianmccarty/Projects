$a = Get-ChildItem C:\Scripts -recurse | Where-Object { $_.PSIsContainer -eq $True }
$a | Where-Object { $_.GetFiles().Count -eq 0 } | Select-Object FullName


(get-childitem C:\users\bmccarty -r | where-object { $_.PSIsContainer -eq $True }) | where-object { $_.GetFiles().Count -eq 0 } | select FullName