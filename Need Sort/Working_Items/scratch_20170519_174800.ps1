Get-ChildItem -Path c:\temp -recurse | get-filehash | Group-Object -property hash | Where-Object { $_.count -gt 1 } | ForEach-Object { $_.group | Select-Object -skip 1 } | Write-Output

Get-ChildItem -Path c:\temp -recurse | get-filehash | Group-Object -property hash | Where-Object { $_.count -gt 1 } | Write-Output | fl

Get-ChildItem -Path c:\temp -recurse | get-filehash | Group-Object -property hash | Where-Object { $_.count -gt 1 } | ForEach-Object { $_.group | Select-Object -skip 1 } | #Remove-Item