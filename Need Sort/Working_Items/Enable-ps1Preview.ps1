#############################################################################
# Enable-ps1Preview.ps1
# This script will enable preview for ps1 files in Windows Explorer.
# Special thanks to Nate Bruneau for the idea.
#
# Created by 
# Bhargav Shukla
# http://www.bhargavs.com
# 
# DISCLAIMER
# ==========
# THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE 
# RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#############################################################################

# Check if OS is Windows 7 or Windows Server 2008 R2, quit if not.
$OS = (Get-WmiObject -Class win32_OperatingSystem -namespace "root\CIMV2" -ComputerName .).caption
switch -wildcard ($OS)
{
  "*Windows 7*" {"`nChecking Elevation..."}
  "*Windows Server 2008 R2*" {"`nChecking Elevation..."}
  default {Write-Host -ForegroundColor Red "`nYou are not running Windows 7 or Windows Server 2008 R2. You can't use this feature on older OS."; exit}
}

# Function to check if PowerShell is running elevated
function Check-Elevated
{
  $wid=[System.Security.Principal.WindowsIdentity]::GetCurrent()
  $prp=new-object System.Security.Principal.WindowsPrincipal($wid)
  $adm=[System.Security.Principal.WindowsBuiltInRole]::Administrator
  $IsAdmin=$prp.IsInRole($adm)
  if ($IsAdmin)
  {
    Set-Variable -Name elevated -Value $true -Scope 1
  }
}

# Make registry changes if running elevated, throw error if not
Check-Elevated
If ($elevated -eq $true)
{
	# Set Registry Key variables
	$REG_KEY = ".ps1"
			
	# Open remote registry
	$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('ClassesRoot', ".")
	
	# Open the targeted remote registry key/subkey as read/write
	$regKey = $reg.OpenSubKey($REG_KEY,$true)
		
	# Set PerceivedType to "text"
	if ($regKey -ne $null)
	{
		$regKey.Setvalue('PerceivedType', 'text', 'String')
		$regKey.Setvalue('Content Type', 'text/plain', 'String')
		
		# Close the Reg Key
		$regKey.Close()
	
		Write-Host -ForegroundColor Green -BackgroundColor Black "Preview for .ps1 files is now enabled. Enable preview pane in Windows Explorer.`n"
			
	}

}
else
{
  Write-Host -ForegroundColor Red -BackgroundColor Black "Please run PowerShell as administrator before you run this script.`n"
}
