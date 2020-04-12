Get-ChildItem -Path "C:\Users\bmccarty\Google Drive\Amber" -Recurse | Where-Object { $_.name -match "\.ptn" } | Remove-Item -Force

Get-ChildItem -path "C:\Users\bmccarty\OneDrive\00-Redirected\Downloads" -Recurse | Where-Object { $_.name -match "\.01\." } | Rename-Item -NewName { $_.name -replace '.01.', '.' }

choco install sysinternals --installationpath 'c:\sysinternals' --yes
choco uninstall dupguru

Get-ChildItem -Path "C:\Users\bmccarty\Resilio Sync" -Recurse | Where-Object { $_.name -match "\.rsls" } | remove-item -Force