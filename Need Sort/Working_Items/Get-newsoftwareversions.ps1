<#
 
.SYNOPSIS
    Checks for the current version of common software and sends an email notification if the version has been updated
 
.DESCRIPTION
    This script checks for the current version of some common software from their internet URLs.  It then checks a local file for the stored software version.  If the two don't match,
    an email will be sent notifying of the new version number.  The stored version number will then be updated for future version checking.
    Currently software list:
    Adobe Flash Player
    Adobe Acrobat Reader DC
    Java Runtime
    Notepad++
    Paint.net
    PDFCreator
 
.PARAMETER To
    The "To" email address for notifications
 
.PARAMETER From
    The "From" email address for notifications
 
.PARAMETER Smtpserver
    The smtpserver name for email notifications
 
.PARAMETER SoftwareVersionsFile
    The location of the file used to store the software versions
 
.EXAMPLE
    Check-SoftwareVersions.ps1
    Checks the internet URLs of common software for the current version number and sends an email if a new version has been released.
 
.NOTES
    Script name: Check-SoftwareVersions.ps1
    Author:      Trevor Jones
    Contact:     @trevor_smsagent
    DateCreated: 2015-06-11
    Link:        https://smsagent.wordpress.com
 
#>


[CmdletBinding(SupportsShouldProcess = $True)]
param
(
	[Parameter(Mandatory = $False, HelpMessage = "The 'to' email address")]
	[string]$To = "bill.gates@contoso.com",
	[Parameter(Mandatory = $False, HelpMessage = "The 'from' email address")]
	[string]$From = "PowerShell@contoso.com",
	[Parameter(Mandatory = $False, HelpMessage = "The 'from' email address")]
	[string]$SmtpServer = "myexchangebox",
	[parameter(Mandatory = $False, HelpMessage = "The location of the software versions file")]
	[string]$SoftwareVersionsFile = "C:\Scripts\temp\SoftwareVersions.txt"
)


$EmailParams = @{
	To		 = $To
	From	   = $From
	Smtpserver = $SmtpServer
}

# Note: to find the element that contains the version number, output all elements to gridview and search with the filter, eg:
# $URI = "https://get.adobe.com/uk/reader/"
# $HTML = Invoke-WebRequest -Uri $URI
# $HTML.AllElements | Out-Gridview


######################
# Adobe Flash Player #
######################

Write-Verbose "Checking Adobe Flash Player"
$URI = "http://www.adobe.com/uk/products/flashplayer/distribution3.html"
$HTML = Invoke-WebRequest -Uri $URI
$NewFlashVersion = (($HTML.AllElements | Where-Object {
			$_.innerHTML -like "Flash Player*Win*"
		}).innerHTML).Split(" ")[2]
Write-Verbose "Found version: $NewFlashVersion"

$CurrentFlashVersion = ((Get-Content $SoftwareVersionsFile | Select-string "Adobe Flash Player").ToString()).substring(20)
Write-Verbose "Stored version: $CurrentFlashVersion"

If ($NewFlashVersion -ne $CurrentFlashVersion)
{
	Write-Verbose "Sending email"
	Send-MailMessage @EmailParams -Subject "Adobe Flash Update" -Body "Adobe Flash Player has been updated from $CurrentFlashVersion to $NewFlashVersion"
	write-verbose "Setting new stored version number for Adobe Flash Player"
	$Content = Get-Content $SoftwareVersionsFile
	$NewContent = $Content.Replace("Adobe Flash Player: $CurrentFlashVersion", "Adobe Flash Player: $NewFlashVersion")
	$NewContent | Out-File $SoftwareVersionsFile -Force
}


###########################
# Adobe Acrobat Reader DC #
###########################

Write-Verbose "Checking Adobe Acrobet Reader DC"
$URI = "https://get.adobe.com/uk/reader/"
$HTML = Invoke-WebRequest -Uri $URI
$NewReaderVersion = (($HTML.AllElements | Where-Object {
			$_.innerHTML -like "Version *.*.*"
		}).innerHTML).Split(" ")[1]
Write-Verbose "Found version: $NewReaderVersion"

$CurrentReaderVersion = ((Get-Content $SoftwareVersionsFile | Select-string "Adobe Acrobat Reader DC").ToString()).Substring(25)
Write-Verbose "Stored version: $CurrentReaderVersion"

If ($NewReaderVersion -ne $CurrentReaderVersion)
{
	Write-Verbose "Sending email"
	Send-MailMessage @EmailParams -Subject "Adobe Acrobat Reader Update" -Body "Adobe Acrobat Reader DC has been updated from $CurrentReaderVersion to $NewReaderVersion"
	write-verbose "Setting new stored version number for Adobe Acrobat Reader DC"
	$Content = Get-Content $SoftwareVersionsFile
	$NewContent = $Content.Replace("Adobe Acrobat Reader DC: $CurrentReaderVersion", "Adobe Acrobat Reader DC: $NewReaderVersion")
	$NewContent | Out-File $SoftwareVersionsFile -Force
}


################
# Java Runtime #
################

Write-Verbose "Checking Java Runtime"
$URI = "http://www.java.com/en/download/windows_offline.jsp"
$HTML = Invoke-WebRequest -Uri $URI
$NewJavaVersion = (($HTML.AllElements | Where-Object {
			$_.innerHTML -like "Recommended Version * Update *"
		}).innerHTML).Substring(20).Split("(")[0]
Write-Verbose "Found version: $NewJavaVersion"

$CurrentJavaVersion = ((Get-Content $SoftwareVersionsFile | Select-string "Java Runtime").ToString()).Substring(14)
Write-Verbose "Stored version: $CurrentJavaVersion"

If ($NewJavaVersion -ne $CurrentJavaVersion)
{
	Write-Verbose "Sending email"
	Send-MailMessage @EmailParams -Subject "Java Runtime Update" -Body "Java Runtime has been updated from $CurrentJavaVersion to $NewJavaVersion"
	write-verbose "Setting new stored version number for Java Runtime"
	$Content = Get-Content $SoftwareVersionsFile
	$NewContent = $Content.Replace("Java Runtime: $CurrentJavaVersion", "Java Runtime: $NewJavaVersion")
	$NewContent | Out-File $SoftwareVersionsFile -Force
}


##############
# Notepad ++ #
##############

Write-Verbose "Checking Notepad++"
$URI = "http://notepad-plus-plus.org/"
$HTML = Invoke-WebRequest -Uri $URI
$NewNotepadVersion = (($HTML.AllElements | Where-Object {
			$_.outerText -like "Download*" -and $_.tagName -eq "P"
		}).innerText).Split(":")[1].Substring(1)
Write-Verbose "Found version: $NewNotepadVersion"

$CurrentNotepadVersion = ((Get-Content $SoftwareVersionsFile | Select-string "Notepad\+\+").ToString()).Substring(11)
Write-Verbose "Stored version: $CurrentNotepadVersion"

If ($NewNotepadVersion -ne $CurrentNotepadVersion)
{
	Write-Verbose "Sending email"
#	Send-MailMessage @EmailParams -Subject "Notepad++ Update" -Body "Notepad++ has been updated from $CurrentNotepadVersion to $NewNotepadVersion"
	write-verbose "Setting new stored version number for Notepad++ $CurrentNotepadVersion - $NewNotepadVersion"
#	$Content = Get-Content $SoftwareVersionsFile
#	$NewContent = $Content.Replace("Notepad++: $CurrentNotepadVersion", "Notepad++: $NewNotepadVersion")
#	$NewContent | Out-File $SoftwareVersionsFile -Force
}


##############
# Paint.net  #
##############

Write-Verbose "Checking Paint.net"
$URI = "http://www.getpaint.net/index.html"
$HTML = Invoke-WebRequest -Uri $URI
$NewPaintVersion = (($HTML.AllElements | Where-Object {
			$_.innerHTML -clike "paint.net*.*.*"
		}).innerHTML).Substring(10)
Write-Verbose "Found version: $NewPaintVersion"

$CurrentPaintVersion = ((Get-Content $SoftwareVersionsFile | Select-string "Paint.net").ToString()).Substring(11)
Write-Verbose "Stored version: $CurrentPaintVersion"

If ($NewPaintVersion -ne $CurrentPaintVersion)
{
	Write-Verbose "Sending email"
	Send-MailMessage @EmailParams -Subject "Paint.Net Update" -Body "Paint.Net has been updated from $CurrentPaintVersion to $NewPaintVersion"
	write-verbose "Setting new stored version number for Paint.net"
	$Content = Get-Content $SoftwareVersionsFile
	$NewContent = $Content.Replace("Paint.net: $CurrentPaintVersion", "Paint.net: $NewPaintVersion")
	$NewContent | Out-File $SoftwareVersionsFile -Force
}


##############
# PDFCreator #
##############

Write-Verbose "Checking PDFCreator"
$URI = "http://www.pdfforge.org/blog"
$HTML = Invoke-WebRequest -Uri $URI
$NewPDFCreatorVersion = ($HTML.AllElements | Where-Object {
		($_.innerHTML -eq $_.innerText) -and $_.tagName -eq "A" -and $_.innerHTML -like "PDFCreator*"
	})[0].innerHTML.Split(" ")[1]
Write-Verbose "Found version: $NewPDFCreatorVersion"

$CurrentPDFCreatorVersion = ((Get-Content $SoftwareVersionsFile | Select-string "PDFCreator").ToString()).Substring(12)
Write-Verbose "Stored version: $NewPDFCreatorVersion"

If ($NewPDFCreatorVersion -ne $CurrentPDFCreatorVersion)
{
	Write-Verbose "Sending email"
	Send-MailMessage @EmailParams -Subject "PDFCreator Update" -Body "PDFCreator has been updated from $CurrentPDFCreatorVersion to $NewPDFCreatorVersion"
	write-verbose "Setting new stored version number for PDFCreator"
	$Content = Get-Content $SoftwareVersionsFile
	$NewContent = $Content.Replace("PDFCreator: $CurrentPDFCreatorVersion", "PDFCreator: $NewPDFCreatorVersion")
	$NewContent | Out-File $SoftwareVersionsFile -Force
}