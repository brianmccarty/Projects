﻿function Publish-HipChatRoomMessage{
<#

.SYNOPSIS
    A powershell script for sending a message to a room in HipChat
.DESCRIPTION
    A powershell script for sending a message to a room in HipChat
.LINK
	https://github.com/lholman/hipchat-ps
.NOTES
    Author: Lloyd Holman
    DateCreated: 04/09/2012
	Requirements: Copy this module to any location found in $env:PSModulePath
.PARAMETER apitoken
	Required. Your HipChat API token, that you can create here https://www.hipchat.com/admin/api
.PARAMETER roomid
	Required. The id of the HipChat room you want to send the message to, find the id from here https://infigosoftware.hipchat.com/history
.PARAMETER from
	Required. The name the message will appear be sent from. Must be less than 15 characters long. May contain letters, numbers, -, _, and spaces.
.PARAMETER message
	Required. The message body. 10,000 characters max.
.PARAMETER colour
	The background colour of the HipChat messag. One of "yellow", "red", "green", "purple", "gray", or "random". (default: yellow)
.PARAMETER notify
	Set whether or not this message should trigger a notification for people in the room (change the tab color, play a sound, etc). Each recipient's notification preferences are taken into account. 0 = false, 1 = true. (default: 0)
.PARAMETER apihost
	The URI of the HipChat api (default: api.hipchat.com)
.EXAMPLE 
	Import-Module Publish-HipChatRoomMessage
	Import the module
.EXAMPLE	
	Get-Command -Module Publish-HipChatRoomMessage
	List available functions
.EXAMPLE
	Publish-HipChatRoomMessage -apitoken e6b4ed16569cb86d272692171d5 5c8 -roomid 49459 -from "lloyd" -message "Test Message http://www.google.com"		
	Execute the module
    Publish-HipChatRoomMessage -apitoken fb6a882a2874cbb512b45a7014f0ef -roomid 3455255 -from $pcname -message "This is a test"
#>
	[cmdletbinding()]
		Param(
			[Parameter(
				Position = 0,
				Mandatory = $True )]
				[string]$apitoken,
			[Parameter(
				Position = 1,
				Mandatory = $True )]
				[string]$roomid,
			[Parameter(
				Position = 2,
				Mandatory = $True )]
				[string]$from,
			[Parameter(
				Position = 3,
				Mandatory = $True )]
				[string]$message,	
			[Parameter(
				Position = 4,
				Mandatory = $False )]
				[string]$colour,
			[Parameter(
				Position = 5,
				Mandatory = $False )]
				[string]$notify,
			[Parameter(
				Position = 6,
				Mandatory = $False )]
				[string]$apihost
				
			)
	Begin {
			$DebugPreference = "Continue"
		}	
	Process {
				Try 
				{
					if ($colour -eq "")
					{
						$colour = "yellow"
					}
					if ($apihost -eq "")
					{
						$apihost = "api.hipchat.com"
					}	
					if ($notify -eq "")
					{
						$notify = "1"
					}		
					
					#Replace naked URL's with hyperlinks
					$regex = [regex] "((www\.|(http|https|ftp|news|file)+\:\/\/)[&#95;.a-z0-9-]+\.[a-z0-9\/&#95;:@=.+?,##%&~-]*[^.|\'|\# |!|\(|?|,| |>|<|;|\)])"
					$message = $regex.Replace($message, "<a href=`"`$1`">`$1</a>").Replace("href=`"www", "href=`"http://www")
					
					#Do the HTTP POST to HipChat
					$post = "auth_token=$apitoken&room_id=$roomid&from=$from&color=$colour&message=$message&notify=$notify"
					Write-Debug "post = $post"
					Write-Debug "https://$apihost/v1/rooms/message"
					$webRequest = [System.Net.WebRequest]::Create("https://$apihost/v1/rooms/message")
					$webRequest.ContentType = "application/x-www-form-urlencoded"
					$postStr = [System.Text.Encoding]::UTF8.GetBytes($post)
					$webrequest.ContentLength = $postStr.Length
					$webRequest.Method = "POST"
					$requestStream = $webRequest.GetRequestStream()
					$requestStream.Write($postStr, 0,$postStr.length)
					$requestStream.Close()
					
					[System.Net.WebResponse] $resp = $webRequest.GetResponse();
					$rs = $resp.GetResponseStream();
					[System.IO.StreamReader] $sr = New-Object System.IO.StreamReader -argumentList $rs;
					$result = $sr.ReadToEnd();					
					
				}
				catch [System.Net.WebException]{
					$result = "$apihost is not a valid host name, please be sure to use the correct host name. `r`n $_.Exception.ToString()" 
				}
				catch [Exception] {
					$result = "Woh!, wasn't expecting to get this exception. `r`n $_.Exception.ToString()"
				}
		}
	End {
			return $result | Format-Table 
		}
}

Publish-HipChatRoomMessage -apitoken fb6a882a2874cbb512b45a7014f0ef -roomid 3455255 -from $pcname -message "Begin hotfix deployment"

#Setup of environment
$domainname = Get-Content env:userdnsdomain
$pcname = Get-Content env:computername
#$64bit = [System.Environment]::Is64BitProcess
$64bit = Get-Content env:PROCESSOR_ARCHITECTURE
New-PSDrive -Name hfserver -PSProvider FileSystem -Root \\$domainname\netlogon\hotfixes

#Get the service status and set it to automatic if disabled or manual
$wustart = Get-WmiObject win32_service -Property startmode -Filter "Name='wuauserv'" | select startmode
If ($wustart.startmode -ne "Automatic") {Set-Service -Name wuauserv -StartupType Automatic}

#Set Windows Update Service to Delayed Auto Start enabled
Set-ItemProperty -Path "Registry::HKLM\System\CurrentControlSet\Services\wuauserv" -Name "DelayedAutoStart" -Value 1 -Type DWORD

#Start the Windows Update Service
Start-Service -Name wuauserv

#Get the Windows Update Service Status and report
$wuservstat = Get-Service -Name wuauserv | select status
Publish-HipChatRoomMessage -apitoken fb6a882a2874cbb512b45a7014f0ef -roomid 3455255 -from $pcname -message "Windows Update Status is $wuservstat"

#Create folder for hotfixes and copy files
New-Item C:\cpihotfixes -Type directory
If ($64bit -eq "AMD64"){
    Copy-Item -Path hfserver:*x64.msu -Destination C:\cpihotfixes
    Publish-HipChatRoomMessage -apitoken fb6a882a2874cbb512b45a7014f0ef -roomid 3455255 -from $pcname -message "Copying x64 files"
    }
Else {
    Copy-Item -Path hfserver:*x86.msu -Destination C:\cpihotfixes
    Publish-HipChatRoomMessage -apitoken fb6a882a2874cbb512b45a7014f0ef -roomid 3455255 -from $pcname -message "Copying x86 files"
    }

    
Publish-HipChatRoomMessage -apitoken fb6a882a2874cbb512b45a7014f0ef -roomid 3455255 -from $pcname -message "Copying Complete"

#Execute the hotfixes
$cpihotfixes = Get-ChildItem -Path C:\cpihotfixes\*

foreach ($cpihotfix in $cpihotfixes) {
    $chfname = $cpihotfix.name
    $chfname
    Publish-HipChatRoomMessage -apitoken fb6a882a2874cbb512b45a7014f0ef -roomid 3455255 -from $pcname -message "Starting $chfname"
    $arglist = "c:\cpihotfixes\$chfname","/quiet","/norestart"
    Start-Process -FilePath "C:\Windows\System32\wusa.exe" -ArgumentList $arglist -NoNewWindow -Wait
    Publish-HipChatRoomMessage -apitoken fb6a882a2874cbb512b45a7014f0ef -roomid 3455255 -from $pcname -message "Finished $chfname"
    }

Publish-HipChatRoomMessage -apitoken fb6a882a2874cbb512b45a7014f0ef -roomid 3455255 -from $pcname -message "Process Complete - Cleaning up"

#Remove the folder and hotfixes
Remove-Item C:\cpihotfixes -Recurse

#Restart the computer
Publish-HipChatRoomMessage -apitoken fb6a882a2874cbb512b45a7014f0ef -roomid 3455255 -from $pcname -message "Restarting"

Restart-Computer -force