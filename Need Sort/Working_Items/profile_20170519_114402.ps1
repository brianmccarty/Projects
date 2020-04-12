<#
NAME: Profile.ps1
AUTHOR: Damien Solodow , Harrison College
DATE CREATED  : 5/4/2012
COMMENT:  intended for use as $profile.CurrentUserAllHosts
 #>

#region Global variables for environment specific settings
$beserver = 'ServerName' # Symantec Backup Exec server; BEMCLI is in BE 2012+
$xaserver = 'ServerName' # Citrix XenApp server; tested with XenApp 6.x
$sharepoint2013 = 'ServerName'  # Microsoft SharePoint 2013 (On-Premise); the server selected needs to be a member of the farm you want to work with
$vcenter = 'ServerName' # VMware vCenter Server. 
$f5 = 'FQDN' # F5 LTM
$excas = 'ServerName' # On Premise Exchange; this should be the name of one of your CAS servers. Tested with Exchange 2010
$tfsurl = 'YourTFSServerURL' # Microsoft TFS Server
$orionserver = 'ServerName' # SolarWinds Orion. Needs to be the actual server name if you have this URL behind a load balancer
$smtpserver = 'YourSMTPServer' # SMTP server you want to use to send email
$adminusername = 'YourAdminAccountUserName' # If you have a separate user account for admin type tasks, provide the DOMAIN\USERNAME here
$o365adminusername = 'YourOffice365UserName' # A global admin account for your tenant
#endregion

#region Version specific settings/functions
If ($psversiontable.psversion -eq '2.0') {
	$PSEmailServer =$smtpserver 
	#create functions to add these modules as PowerShell 2.0 doesn't support module auto-loading
	Function Add-MSSQL {
		Import-Module -Name SQLPS -DisableNameChecking
		Update-PSTitleBar 'MSSQL'
	}
}
ElseIf  ($psversiontable.psversion -ge '3.0') {
	 # set default parameters on various commands. See 'Help about_Parameters_Default_Values' for more info
	 $PSDefaultParameterValues=@{
	 	'Format-Table:AutoSize'=$True;
	 	'Get-Help:ShowWindow'=$True;
	 	'Send-MailMessage:SmtpServer'=$smtpserver
	  }
	 $Env:ADPS_LoadDefaultDrive = 0  # prevents the ActiveDirectory module from creating the AD: PSDrive on import
	 If ($host.name -eq 'ConsoleHost') { 
	 	If (Get-Module -ListAvailable -Name PSReadline) {
	 		Import-Module -Name 'PSReadLine' # you can get this module here: https://github.com/lzybkr/PSReadLine
	 		Set-PSReadlineKeyHandler -Key Enter -Function AcceptLine # workaround for: https://github.com/lzybkr/PSReadLine/issues/162
		}	 		
	}	 	
}#endregion

#region host (Console vs ISE) specific items
# Since we're using the AllHosts profile, this is how you break out things you only want in one host or the other
If ($host.name -eq 'ConsoleHost') { # ConsoleHost is the 'standard' PowerShell console
	# customize title bar; adds the - so the module names added by Update-PSTitleBar don't run together
	$host.ui.rawui.windowtitle = $host.ui.rawui.windowtitle+" -"
	# the default prompt is PS version specific, but you can make it whatever you desire
	Function prompt { 
	   Write-Host -Object ("PS $($executionContext.SessionState.Path.CurrentLocation)$(">" * ($nestedPromptLevel + 1))") -nonewline -foregroundcolor Green
	   return " "
	}
}
ElseIf ($host.name -eq 'Windows PowerShell ISE Host'){
	If (Get-Module -ListAvailable -Name 'ScriptBrowser') { # you can grab this here: http://www.microsoft.com/en-us/download/details.aspx?id=42525
		Enable-ScriptBrowser
		Enable-ScriptAnalyzer
	}
}
#endregion	

#region Aliases - creating aliases for some apps that are handy to invoke from the console; this is especially useful for ones that aren't on the path
$pscriptPath = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\PrimalScript.exe' -ErrorAction SilentlyContinue
if (-not($pscriptPath)) {
    Write-Warning -Message 'Unable to create pscript alias; PrimalScript may not be installed.'
}        
Else {
    Set-Alias -Name 'pscript' -Value $pscriptPath.'(default)'
}
	
$nppPath = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\notepad++.exe' -ErrorAction SilentlyContinue
if (-not($nppPath)) {
    Write-Warning -Message 'Unable to create npp alias; NotePad++ may not be installed.'
}        
Else {
    Set-Alias -Name 'npp' -Value $nppPath.'(default)'
}

Set-Alias -Name 'ie' -Value 'C:\Program Files (x86)\Internet Explorer\iexplore.exe'
#endregion

#region PSDrives
New-PSDrive -Name 'MyDocs' -PSProvider FileSystem -Root (Get-ItemProperty -Path 'HKCU:\software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders').Personal -ErrorAction SilentlyContinue | Out-Null
#endregion	

#region Functions
# These could be split out into a script module if desired.

Function Set-DigitalSignature { # you can get a code signing cert from your internal CA or one of the public ones
	Param ([parameter(Mandatory = $true,Position=0)][String]$filename)
	$codecert = Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert
	If (-not($codecert)) {
		Write-Warning -Message "You don't have a code signing certificate installed"
	}
	Else {
		Set-AuthenticodeSignature -Certificate $codecert -TimestampServer 'http://timestamp.digicert.com' -FilePath $filename
	}	
}
	
 Function Update-PSTitleBar { 
 	Param ([parameter(Mandatory = $true,Position=0)][String]$newmod)
	#only use on console host; since ISE shares the WindowTitle across multiple tabs, this information is misleading in the ISE.
	If ($host.name -eq 'ConsoleHost') {
		$host.ui.RawUI.WindowTitle = $host.ui.RawUI.WindowTitle+" $newmod "
	}
 }
 
Function Get-AdminCred { # stuff your admin account credentials into a variable for use later
	 If (-not($admin)) {
	 	$global:admin = Get-Credential -Credential $adminusername
	 }
}
New-Alias -Name 'sudo' -Value 'Get-AdminCred' 

Function Get-O365AdminCred { # stuff your Office 365 admin account credentials into a variable for use later
	 If (-not($o365admin)) {
	 	$global:o365admin = Get-Credential -Credential $o365adminusername
	 }
}

Function Start-Elevated { # let's you start a process/app as if you chose Run As Administrator
       [CmdletBinding()]
    Param (
        [parameter(Mandatory = $true,ValueFromPipeline=$true,Position=0)] [String]$FilePath,
        [parameter(Mandatory = $false,ValueFromRemainingArguments=$true,Position=1)] [String[]]$ArgumentList
    )
       Start-Process -verb RunAs @PSBoundParameters
}

Function Update-HostsFile {
	if (-not(Get-Alias -Name 'npp')) {
    		Start-Elevated -FilePath notepad -ArgumentList $env:windir\system32\drivers\etc\hosts
    	}
	Else { #notepad++ has a SaveAsAdmin plugin that solves the elevation issue
    		npp $env:windir\system32\drivers\etc\hosts
	}
}

Function Sync-AD { # let's you trigger a replication between DCs. This function needs further tweaks for re-usability
       [CmdletBinding()]
    Param (
        [parameter(Mandatory = $false,Position=0)] [String]$DestinationDC = 'centralDC',
        [parameter(Mandatory = $false,Position=1)] [String]$SourceDC = 'localDC',
        [parameter(Mandatory = $false,Position=2)] [String]$DirectoryPartition = 'YourDomainName'
    )
       Get-AdminCred
       Start-Process -Credential $admin -FilePath repadmin -ArgumentList "/replicate $DestinationDC $SourceDC $DirectoryPartition" -WindowStyle Hidden
}

Function Add-Equallogic { # This needs the Host Integration Tools installed. 
	If (-not(get-childitem -Path 'HKLM:\Software\EqualLogic\PSG' -ErrorAction SilentlyContinue)) {
	    Write-Warning 'No group configured; you need to run New-EqlGroupAccess in an elevated PowerShell session before you can use the EQL cmdlets'
	}	
	if (-not (Get-Module -Name 'eqlpstools')) {
		Import-Module -Name 'C:\Program Files\EqualLogic\bin\EqlPSTools.dll'
		Update-PSTitleBar 'EqualLogic'
		$EQLArrayName = (get-childitem -Path 'HKLM:\Software\EqualLogic\PSG').pschildname
		Write-Host -Object "Connect to the array with Connect-EqlGroup -Groupname $EQLArrayName" -Foregroundcolor yellow
	}
}

Function Add-VMware { # This requires PowerCLI
	If (-not(Get-PSSnapin -Name 'VMware*' -ErrorAction SilentlyContinue)) {
		Add-PSSnapin -Name (Get-PSSnapin -Registered -Name 'VMware*')
		Function global:Connect-VMware{
			Get-AdminCred
			Connect-VIServer -Server $vcenter -Credential $admin
		}			
		Function global:Enable-VMMemHotAdd($VM){ # Lets you enable Memory Hot Add on a VM while it's running. Requires a stun/unstun cycle to take effect
			 $vmview = Get-VM -VM $vm | Get-View 
			 $vmConfigSpec = New-Object -TypeName VMware.Vim.VirtualMachineConfigSpec
			 $extra = New-Object -TypeName VMware.Vim.optionvalue
			 $extra.Key='mem.hotadd'
			 $extra.Value='true'
			 $vmConfigSpec.extraconfig += $extra
			 $vmview.ReconfigVM($vmConfigSpec)
		}
		Function global:Update-VMHardwareVersion($VM){ # Schedules the VM hardware version upgrade for the next power cycle of the VM. vmx-10 is for vSphere 5.5
			$vm1 = Get-VM -Name $vm
			$spec = New-Object -TypeName VMware.Vim.VirtualMachineConfigSpec
			$spec.ScheduledHardwareUpgradeInfo = New-Object -TypeName VMware.Vim.ScheduledHardwareUpgradeInfo
			$spec.ScheduledHardwareUpgradeInfo.UpgradePolicy = 'onSoftPowerOff'
			$spec.ScheduledHardwareUpgradeInfo.VersionKey = 'vmx-10'
			$vm1.ExtensionData.ReconfigVM_Task($spec)
		}
		Function global:set-VMChangeBlockTracking($VM){ # Lets you enable Change Block Tracking on a VM while it's running. Requires a stun/unstun cycle to take effect
			$vmview = Get-VM $VM | Get-View
			$vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
			$vmConfigSpec.changeTrackingEnabled = $Enable
			$vmview.reconfigVM($vmConfigSpec)
		}
		Function global:Find-OutdatedVMTools {
			Get-VM | Where-Object {$_.ExtensionData.Guest.ToolsStatus -eq "toolsOld"} | Sort-Object name |Format-Table -AutoSize -Property name,powerstate
		}
		Update-PSTitleBar 'VMware'
	}
}

Function Add-Exchange { # tested with the Exchange Management Tools installed locally; may not require them. May work as-is for Exchange 2013, but untested
	If (-Not(Get-PSSession -Name 'Exchange2010' -ErrorAction SilentlyContinue)) {
		Get-AdminCred
		New-PSSession -ConnectionURI "http://$excas/powershell" -ConfigurationName 'Microsoft.Exchange' -name 'Exchange2010' -cred $admin | Out-Null
		Import-PSSession -Session (Get-PSSession -Name 'Exchange2010') -DisableNameChecking | Out-Null
		Update-PSTitleBar 'Exchange'
	}
}

Function Add-ExchangeOnline { 
	If (-Not(Get-PSSession -ConfigurationName 'Microsoft.Exchange' -ErrorAction SilentlyContinue)) {
        Get-O365AdminCred
		$ExOnlineSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $o365admin -Authentication Basic -AllowRedirection
		Import-PSSession -Session $ExOnlineSession -DisableNameChecking -Prefix O365 | Out-Null
		Update-PSTitleBar 'Exchange Online'
	}
}

Function Add-Orion { # depends on Orion SDK; grab it here: https://thwack.solarwinds.com/thread/39001
	If (-not(Get-PSSnapin -Name 'SwisSnapIn' -ErrorAction SilentlyContinue)) {
		Add-PSSnapin -Name 'SwisSnapIn'
		Function global:Connect-Orion {
			$global:orion = Connect-Swis -Hostname $orionserver -Trusted
		}		
		Update-PSTitleBar 'Orion'
		Function global:Disable-OrionNode($swnode){ # unmanages specified node for 4 hours. needs improvement.
			$now = [DateTime]::Now
			$swnodeid = Get-SwisData -SwisConnection $orion -Query 'Select NodeID From Orion.Nodes Where NodeName = @h'@{h=$swnode}
			Invoke-SwisVerb -SwisConnection $orion -EntityName Orion.Nodes -Verb Unmanage @("N:$swnodeid",$now,$now.AddHours(4),$True)
		}
		Function global:Enable-OrionNode($swnode){ # re-manages specified node. needs improvement
			$now = [DateTime]::Now
			$swnodeid = Get-SwisData -SwisConnection $orion -Query 'Select NodeID From Orion.Nodes Where NodeName = @h'@{h=$swnode}
			Invoke-SwisVerb -SwisConnection $orion -EntityName Orion.Nodes -Verb Remanage @("N:$swnodeid",$now,$True)
		}
	}
}

Function Add-XenApp{ # using implicit remoting because the XenApp snapin *has* to be run from a XenApp server in the farm.
	If (-Not(Get-PSSession -Name 'XenApp65' -ErrorAction SilentlyContinue)) {
		Get-AdminCred
		$xa65 = New-PSSession -ComputerName $xaserver -Credential $admin -Name 'XenApp65'
		Invoke-Command -Session $xa65 -ScriptBlock {Add-PSSnapin -Name 'Citrix.XenApp.Commands'}
		Import-PSSession -Session $xa65 -Module 'citrix.xenapp.commands' -FormatTypeName * | Out-Null
		Update-PSTitleBar 'XenApp'
	}
}

Function Add-BackupExec {  
	If (-Not(Get-PSSession -Name 'BackupExec' -ErrorAction SilentlyContinue)) {
		Get-AdminCred
		$be = New-PSSession -ComputerName $beserver -Credential $admin -Name BackupExec
		Invoke-Command -Session $be -ScriptBlock {import-module -Name 'bemcli'}
		Import-PSSession -Session $be -Module 'bemcli' -FormatTypeName * | Out-Null
		Update-PSTitleBar 'BackupExec'
	}
}	 	

Function Add-SharePoint { # this needs to connect to a server in the farm, AND it needs to use CredSSP due to the number of cmdlets that have to hop to SQL. CredSSP needs to be setup on both client and server
	If (-Not(Get-PSSession -Name 'SharePoint2013' -ErrorAction SilentlyContinue)) {
		Get-AdminCred
		$spps = New-PSSession -ComputerName $sharepoint2013 -Authentication CredSSP -Credential $admin -Name SharePoint2013
		Invoke-Command -Session $spps -ScriptBlock {Add-PSSnapin -Name 'Microsoft.SharePoint.PowerShell'}
		Import-PSSession -Session $spps -Module 'Microsoft.SharePoint.PowerShell' -FormatTypeName * -DisableNameChecking
		Update-PSTitleBar 'SharePoint'
	}		
}	

Function Add-F5 {# the snapin is available here: https://devcentral.f5.com/d/microsoft-powershell-with-icontrol
	If (-not(Get-PSSnapin -Name 'iControlSnapIn' -ErrorAction SilentlyContinue)) {
		Get-AdminCred
		Add-PSSnapin -Name 'iControlSnapIn'
		$global:f5admin = new-object -typename System.Management.Automation.PSCredential -argumentlist ($admin.username.split('\')[1]),$admin.password
		Update-PSTitleBar 'F5'
		Function global:Connect-F5 {
			Initialize-F5.iControl -HostName $f5 -PSCredentials $f5admin
		}	
	}
}

Function Add-Tfs {# this snapin is part of the TFS PowerTools, but you have to do a custom install as the default doesn't install the PowerShell tools
	If (-not(Get-PSSnapin -Name 'Microsoft.TeamFoundation.PowerShell' -ErrorAction SilentlyContinue)) {
		 Add-PSSnapin -Name 'Microsoft.TeamFoundation.PowerShell'
		 $global:myTFSWorkSpace = Get-TfsServer -servername $tfsurl | Get-TfsWorkspace
		 $global:myTFSWorkSpaceFolder = $myTFSWorkSpace.Folders.LocalItem
	}		 
}
#endregion