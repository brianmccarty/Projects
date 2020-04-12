"       -------------------------------------------"
"       ##     FTP VIRTUAL DIRECTORY CREATION SCRIPT     ##"
""
""
"       ## This script will create a new username, password, local directory, and virtual directory for a client "
""
"       ## Please enter the following information "
""
"       -------------------------------------------"
 
 
### PowerShell Script
### Create local User Acount
 
$AccountName = Read-Host "Please enter user account name (i.e. username)"
$FullName = Read-Host "Please enter the full name (i.e. Username Company)"
$Description = Read-Host "Please enter the description (i.e. Username FTP Login)"
$Password = Read-Host "Please enter a password"
$Computer = "CPI-WEB01"
 
"Creating user on $Computer"
 
# Access to Container using the COM library
$Container = [ADSI] "WinNT://$Computer"
 
# Create User
$objUser = $Container.Create("user", $Accountname)
$objUser.Put("Fullname", $FullName)
$objUser.Put("Description", $Description)
 
# Set Password
$objUser.SetPassword($Password)
 
# Save Changes
$objUser.SetInfo()
 
# Add User Flags
# The numbers are bitwise - 65536 is Password Never Expires ; 64 is User Cannot Change Password
 
$objUser.userflags = 65536 -bor 64
$objUser.SetInfo()
 
"User $AccountName created!"
" ------------------------" 



#	---Create FTP local directory---

"Creating directory E:\ftproot\LocalUser\$AccountName"

New-Item E:\ftproot\LocalUser\$AccountName -type directory  
Start-Sleep -Seconds 5
"Directory $AccountName created!"
" ------------------------"


#	---Set Permissions on Folder

"Setting Permissions on E:\ftproot\LocalUser\$AccountName"

$colRights = [System.Security.AccessControl.FileSystemRights]"Modify"
$Inherit = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
$Propagate = [System.Security.AccessControl.PropagationFlags]::None
$objType =[System.Security.AccessControl.AccessControlType]::Allow
$User = New-Object System.Security.Principal.NTAccount("$Computer\$AccountName")
$objACE = New-Object System.Security.AccessControl.FileSystemAccessRule($User, $colRights , $Inherit, $Propagate, $objType)

$objACL = Get-Acl "E:\ftproot\LocalUser\$AccountName"

$objACL.AddAccessRule($objACE)

Set-Acl "E:\ftproot\LocalUser\$AccountName" $objACL

Start-Sleep -Seconds 5

"Permissions Successfully Applied!"
" ------------------------"



#	---Create Virtual Directory in IIS---

"Creating virtual directory in IIS"
Start-Sleep -Seconds 5

IIS:

New-Item "IIS:\Sites\CPI FTP Site\LocalUser\$AccountName" -type VirtualDirectory -physicalPath "E:\ftproot\LocalUser\$AccountName"
Add-WebConfiguration "/system.ftpServer/security/authorization"  -value @{accessType="Allow";users="$Computer\$AccountName";permissions=3} -PSPath IIS:\ -location "CPI FTP Site/LocalUser/$AccountName"





"FTP site $AccountName created!"
" ------------------------"