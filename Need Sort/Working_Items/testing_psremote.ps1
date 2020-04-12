Enable-PSRemoting -Force
Set-Item wsman:\localhost\client\trustedhosts *
Restart-Service WinRM
Test-WsMan -ComputerName 192.168.7.29

Invoke-Command -ComputerName 192.168.7.29 -ScriptBlock { Get-ChildItem C:\ } -credential "bkmccarty#outlook.com"


cd