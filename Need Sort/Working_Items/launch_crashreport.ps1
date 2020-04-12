# Launch_crashreport.ps1
# Launch debug analysis logs using KD
# Kevin Patrick 1/26/2011
#
# Usage: ./launch_crashreport.ps1
#
# Output: Log file to standard output to C:\Windows\dumpsprocessed
#
# Note:  Powershell and Debugging Tools for Windows must be installed
#
#################################################################################################################

#OU dump
 $strCategory = "computer"
 $objDomain = New-Object System.DirectoryServices.DirectoryEntry
 $objOU = New-Object System.DirectoryServices.DirectoryEntry("LDAP://OU=OU,OU=OU,OU=OU,DC=DC,DC=XX.com")
 #$objOU = New-Object System.DirectoryServices.DirectoryEntry("LDAP://OU=OU,OU=OU,OU=OU,DC=DC,DC=XX.com")

 $objSearcher = New-Object System.DirectoryServices.DirectorySearcher
 $objSearcher.SearchRoot = $objOU
 $objSearcher.Filter = ("(objectCategory=$strCategory)")
 $colResults = $objSearcher.FindAll()

#Output server names in OU to C:\servers.txt on launch server
  foreach ($objResult in $colResults)
  {$objComputer = $objResult.Properties; $objComputer.name | Out-File "c:\servers.txt" -append}

#Invoke-Command -filePath example in PowerShell 2.0
 invoke-Command -computerName (Get-Content "C:\Servers.txt") -filePath "\\FileServer\FileShare\Crashreport.ps1"

#Delete C:\servers.txt from launch server.  -append above will continually add server names to .txt file without logic.
 del "c:\servers.txt"

Add the script above to a scheduled task that runs once a day, or whatever intervals you desire.

Also, run the following commands on each server to allow PSRemoting and to open the execution policy.

Powershell.exe set-executionpolicy unrestricted
powershell.exe enable-psremoting -force 

# crashreport.ps1
# Create debug analysis logs using KD
# Kevin Patrick 1/21/2011
#
# Usage: ./crashreport.ps1
#
#
# Output: Log file to standard output to C:\Windows\dumpsprocessed
#
# Note:  Debugging Tools for Windows must be installed
# in its default directory (Program Files (X86)\Debugging Tools For Windows)
#
 $Notify = "someone@somewhere.com"
 $timestamp = $(Get-Date -f hh.mm.ss_dd.MM.yy)
 $dumpmove = $ENV:WinDIR + "\dumpsprocessed\" + $timestamp 
 $crashdumpfile = $ENV:WinDIR + "\minidump*.dmp"
 $crashdumpfile2 = $ENV:WinDIR + "*.dmp"

#If C:\Windows\dumprocessed dir does not exist, create dir

 if (!(Test-Path -path $dumpmove))
  {
  New-Item $dumpmove -type directory
  }

 Set-Alias kd "C:\Program Files (x86)\Debugging Tools for Windows (x86)\kd.exe"

# Debug commands are specified here.  See the Debugging Tools For
# Windows for more details
#
# Commands are:  !analyze -v    Verbose analysis of the crash
#                kv             Stacktrace
#                !process       Current process and thread at crash
#                lmf            List loaded modules and file paths
#                q              quit KD (or else KD will keep running)
#
 $debugcommands = "`"!analyze -v; kv; !process; lmf; q`""

# PowerShell Foreach to generate crashdump file
 clear host
 Get-ChildItem $crashdumpfile | foreach{
 $logfile = $dumpmove + "\" + $_.name + ".log"

# Execute kd with commands
 kd -c $debugcommands -noshell -logo $logfile -z $_.fullname

#Screen output
 Add-Content $logfile ("`n Finished debugging: " + $_.fullname )
 Add-Content $logfile ("`n Debug Output to log file: " + $logfile)
 Add-Content $logfile ("`n Processed dump files and log files can be found: " + $dumpmove)

#Email
 $Message = (Get-Content $logfile) 
 $Message = [string]::join([environment]::NewLine,$Message)
    $mail = New-Object System.Net.Mail.MailMessage

 #set the addresses
 $mail.From = New-Object System.Net.Mail.MailAddress("dump_analyses" + "@" + $Env:COMPUTERNAME + ".citrite.net");
 $mail.To.Add($Notify);
 
 #set the content
 $mail.Subject = "$Env:COMPUTERNAME - $_ was analyzed"
 $mail.Body = $Message;
 
 #send the message
 $smtp = new-object System.Net.Mail.SmtpClient("smtpserver.somewhere.com");
 
 #to authenticate we set the username and password properites on the SmtpClient
 #$smtp.Credentials = new-object System.Net.NetworkCredential("username", "password");
 $smtp.Send($mail);

#Move proccessed .dmp file to C:\Winodws\dumpsprocessed
 move $_.fullname $dumpmove }

# PowerShell Foreach to generate crashdump file
 clear host
 Get-ChildItem $crashdumpfile2 | foreach{
 $logfile = $dumpmove + "\" + $_.name + ".log"

# Execute kd with commands
 kd -c $debugcommands -noshell -logo $logfile -z $_.fullname

#Screen output
 Add-Content $logfile ("`n Finished debugging: " + $_.fullname )
 Add-Content $logfile ("`n Debug Output to log file: " + $logfile)
 Add-Content $logfile ("`n Processed dump files and log files can be found: " + $dumpmove)

#Email
 $Message = (Get-Content $logfile) 
 $Message = [string]::join([environment]::NewLine,$Message)
    $mail = New-Object System.Net.Mail.MailMessage

 #set the addresses
 $mail.From = New-Object System.Net.Mail.MailAddress("dump_analyses" + "@" + $Env:COMPUTERNAME + ".citrite.net");
 $mail.To.Add($Notify);
 
 #set the content
 $mail.Subject = "$Env:COMPUTERNAME - $_ was analyzed"
 $mail.Body = $Message;
 
 #send the message
 $smtp = new-object System.Net.Mail.SmtpClient("hqsmtp.citrite.net");
 
 #to authenticate we set the username and password properites on the SmtpClient
 #$smtp.Credentials = new-object System.Net.NetworkCredential("username", "password");
 $smtp.Send($mail);

#Move proccessed .dmp file to C:\Winodws\dumpsprocessed
move $_.fullname $dumpmove 
#Cleanup empty folder in C:\Windows\dumpsprocessed
 $cleanup = Get-ChildItem "C:\Windows\dumpsprocessed" -Recurse
 foreach($item in $cleanup)
{
      if( $item.PSIsContainer )
      {
            $subitems = Get-ChildItem -Recurse -Path $item.FullName
            if($subitems -eq $null)
            {
                  "Remove item: " + $item.FullName
                  Remove-Item $item.FullName
        }
            $subitems = $null
      }