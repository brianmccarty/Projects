Clear-Host
$Directory = "C:\Windows\"
$Phrase = "Error"
$Files = Get-Childitem $Directory -recurse -include *.log `
-errorAction SilentlyContinue
$Files | Select-String $Phrase -errorAction SilentlyContinue `
| Group-Object filename | Sort-Object count -descending