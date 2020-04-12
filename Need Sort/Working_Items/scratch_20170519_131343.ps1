Get-Mailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq "UserMailbox" } | Set-Mailbox -AuditEnabled $true
Get-Mailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq "UserMailbox" } | Set-Mailbox -AuditOwner MailboxLogin, HardDelete, SoftDelete
Get-Mailbox -ResultSize Unlimited -Filter { RecipientTypeDetails -eq "UserMailbox" } | FL Name, Audit*



$user = Get-Mailbox -ResultSize Unlimited -Filter { (RecipientTypeDetails -eq "UserMailbox") -and (Alias -ne "marketingcampaigns") } | select identity
$user
$user | foreach { Set-Mailbox $_.identity -AuditEnabled $true }


