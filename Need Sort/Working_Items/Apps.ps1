$choco = choco list --local-only 
$apps = Get-WmiObject -Class win32_product
$apps | Export-Csv -path C:\Users\bmccarty\OneDrive\00-Redirected\Desktop\apps.csv -NoTypeInformation
$choco | Export-Csv -path C:\Users\bmccarty\OneDrive\00-Redirected\Desktop\choco.csv -NoTypeInformation