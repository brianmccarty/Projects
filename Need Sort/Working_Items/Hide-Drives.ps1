#Hidecalc cut & paste for PowerShell Script
#Hide and Restrict Access to Drives  A, B, C, D, Z, as defined by hidecalc
$RegKey ="HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
Set-ItemProperty -path $RegKey -name NoDrives -value 33554447-type DWORD
$RegKey ="HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
Set-ItemProperty -path $RegKey -name NoViewOnDrive -value 33554447 -type DWORD