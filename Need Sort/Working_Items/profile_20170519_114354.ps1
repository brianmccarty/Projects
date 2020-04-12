Function backUp-Profile()

{

 $dte = get-date

 $buName = $dte.tostring() -replace “[\s:{/}]”,”_”

 $buName = $buName + “_Profile”

 copy-item -path $profile -destination “C:\trans\backup\ISE$buName.ps1”

} #end backup-Profile