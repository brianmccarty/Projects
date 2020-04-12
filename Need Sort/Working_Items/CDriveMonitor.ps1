#Variables
$path="."
$email="CPISolutions@menemsha.com"
$smtp="los-mail02"
$datevar= Get-Date -Format "yyyy-MM-dd"
$cdriveArray= New-Object System.Collections.ArrayList

#Query C Drive of Servers
Import-Module AcriveDirectory
$servers = '','','',''
    foreach ($server in $servers){
        $out="";$dns="";$status=""
        $dns=[system.net.dns]::GetHostByName($server.name)
            if($dns.HostName)
                {$status=((New-Object system.net.networkinginformation.ping).send($server.name, 1500)).status}
                if($status -eq "Success")
                {
                $cfree="";$cfree=[math]::Round($((Get-WmiObject -Class Win32_LogicalDisk -ComputerName $server.name | Where-Object {$_.deviceid -eq 'C:'}).freespace)/1073741824,2)
                $csize="";$csize=[math]::Round($((Get-WmiObject -Class Win32_LogicalDisk -ComputerName $server.name | Where-Object {$_.deviceid -eq 'C:'}).size)/1073741824,2)
                $cpercentfree=[math]::Round($(($cfree/$csize)*100),0)
                $out= "$($server.name)" + "," + "$($cpercentfree)" + "," + "$($cfree)" + "," + "$($server.description)"
                $cdrivearray.add($out)
                }
            }
        "server,cpercentfree,cgbfree,desc" | Out-File servercdrive.csv
        $cdrivearray | Out-File -Append servercdrive.csv

# Generate Email
$servers= Import-Csv $path\servercdrive.csv
$servers2= $servers | Select-Object server,cpercentfree,cgbfree,desc | Where-Object {$($_.cgbfree).length -gt 0} | Sort-Object {[int] $_.cpercentfree} | Select-Object -First 20
$body= "";$body+="<table border=0 width=100%>"
$body+="<tr><td colspan=3><hr>C drive % free - smallest 20<hr></td></tr>"
        
    foreach ($line in $servers2){
        $body+= "<tr><td width-20%><font color=blue>$($line.server)</font></td><td width=20%><font color=blue>
        $([int]$([decimal]$($line.cgbfree))) GB free</font></td><td width=60%><font color=blue>$($line.desc)</font></td></tr>"
        }


# Send Email
Send-MailMessage -From $email -To $email -Subject "Server C Drive Free - $datevar" -Body $body -SmtpServer $smtp -BodyAsHtml


    