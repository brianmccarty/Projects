$snapins = Get-PSSnapin -Registered
$snapins | Add-PSSnapin
 
Get-Module -ListAvailable | Import-Module

Get-PSSnapin | Format-Table -autosize PSVersion, Name
Get-Module | Format-Table -autosize ModuleType, Name
 
function ff ([string] $glob) { get-childitem -recurse -include $glob }

function osr { shutdown -r -t 5 }

function osh { shutdown -h -t 5 }

function rmd ([string] $glob) { remove-item -recurse -force $glob }

function whoami { (get-content env:\userdomain) + "\" + (get-content env:\username); }

function strip-extension ([string] $filename) 
{ 
    [system.io.path]::getfilenamewithoutextension($filename)
} 

function New-PSSecureRemoteSession
{
	param ($sshServerName, $Cred)
	$Session = New-PSSession $sshServerName -UseSSL -Credential $Cred -ConfigurationName C2Remote
	Enter-PSSession -Session $Session
}

function New-PSRemoteSession
{
	param ($shServerName, $Cred)
	$shSession = New-PSSession $shServerName -Credential $Cred -ConfigurationName C2Remote
	Enter-PSSession -Session $shSession
}

function prompt
{
	$promptText = "PS>";
	$wi = [System.Security.Principal.WindowsIdentity]::GetCurrent()
	$wp = new-object 'System.Security.Principal.WindowsPrincipal' $wi
	if ( $wp.IsInRole("Administrators") -eq 1 )
	{
		$color = "Red"
		$title = "**ADMIN** on " + (hostname);
	}
	else
	{
		$color = "Green"
		$title = hostname;
	}
	write-host $promptText -NoNewLine -ForegroundColor $color
	$host.UI.RawUI.WindowTitle = $title;
	return " "
}

function gototrunk{set-location C:\projects\ncontinuity2\trunk}
function gotoprojects{set-location C:\projects}
function gotoprofile{set-location C:\Users\paul.cowan\Documents\WindowsPowerShell}
function gotobuild{set-location "C:\projects\continuity2\build\net-4.0\debug\_PublishedWebsites"}
function gotodownloads{set-location C:\Users\paul.cowan\Downloads}
function gotoncontinuity2{set-location c:\projects\ncontinuity2}
function gotolead{set-location c:\projects\leadcapturer}
function gotocurrent{set-location "C:\projects\ncontinuity2\branches\2.4.0"}
function gotocurrentbuild{set-location "C:\projects\ncontinuity2\branches\2.4.0\build\net-4.0\debug\_PublishedWebsites"}
function openscratch{notepad C:\users\paul.cowan\desktop\scratch.txt}
function opencatscratch{cat C:\users\paul.cowan\desktop\scratch.txt}
function gotoc2{set-location C:\projects\continuity2}

set-alias notepad "C:\Program Files (x86)\Notepad++\notepad++.exe"
set-alias zip "C:\Program Files\7-Zip\7z.exe"
set-alias grep select-string
set-alias ssh New-PSSecureRemoteSession
set-alias sh New-PSRemoteSession
set-alias grep select-string
set-alias ssh New-PSSecureRemoteSession
set-alias sh New-PSRemoteSession
set-alias tr gototrunk
set-alias pr gotoprojects
set-alias profile gotoprofile
set-alias build gotobuild
set-alias downloads gotodownloads
set-alias nc gotoncontinuity2
set-alias lead gotolead
set-alias live gotocurrent
set-alias live_build gotocurrentbuild
set-alias scratch openscratch
set-alias catscratch opencatscratch
set-alias ie "C:\Program Files\Internet Explorer\iexplore.exe"
set-alias c2 gotoc2
set-alias c2web "C:\projects\continuity2\ncontinuity2.web.sln"