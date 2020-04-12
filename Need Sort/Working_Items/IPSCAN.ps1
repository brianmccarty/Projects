## ***************************** 
## TestRange by ByteRebel 
## 13.07.2010 
## ***************************** 
## Test-Connection a range of IPs and resolve DNS Name when sucessfull 
## you must give the script 3 Arguments 
## Example: 
## TestRange.ps1 9 50 54 
## This would test the Range 10.155.9.50 to 10.155.9.54 
 
$bereich = $args[0] 
$args[1]..$args[2] | foreach-object {if (test-connection -computername  10.1.$bereich.$_ -count 1 -quiet) {[net.dns]::gethostbyaddress("10.169.$bereich.$_")}} | select hostname,addresslis