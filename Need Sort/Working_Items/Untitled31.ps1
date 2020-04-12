BREAK

# Add permission to the calendar

Add-MailboxFolderPermission calendar@company.com:\Calendar -User dude@company.com -AccessRights Author

#Note: AccessRights can be: Owner, PublishingEditor, Editor, PublishingAuthor, Author, NonEditingAuthor, Reviewer, Contributor, AvailabilityOnly, LimitedDetails


# Get permission for a specific users

Get-MailboxFolderPermission -Identity calendar@company.com:\Calendar -User dude@company.com


#To remove permissions for a specific user:

Remove-MailboxFolderPermission -Identity calendar@company:\calendar -user dude@company.com
 

#UPDATE:

#What if you need to change the calendar permissions for all users within your organization?!

#$allmailbox = Get-Mailbox -Resultsize Unlimited
 
#Foreach ($Mailbox in $allmailbox)
#{
#    $path = $Mailbox.alias + ":\" + (Get-MailboxFolderStatistics $Mailbox.alias | Where-Object { $_.Foldertype -eq "Calendar" } | Select-Object -First 1).Name
#    Set-mailboxfolderpermission –identity ($path) –user Default –Accessrights AvailabilityOnly
#}


