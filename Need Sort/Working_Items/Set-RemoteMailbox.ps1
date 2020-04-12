<#
	.SYNOPSIS
		Prompt for input of mailbox identity and email address to be added, then add them to the user.

	.DESCRIPTION
		Prompt for input of mailbox identity and email address to be added, then add them to the user.

#>

$identity = Read-Host -Prompt 'Enter mailbox identity'
$addemail = Read-Host -Prompt 'Enter email address to be added'

Set-RemoteMailbox "$identity" -EmailAddresses @{
	add = "$addemail"
}

Get-Recipient -Identity "$identity" | Select-Object *