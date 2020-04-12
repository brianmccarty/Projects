$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

Import-PSSession $Session

Set-mailbox crit@ci.ventura.ca.us -Type Room

Set-CalendarProcessing "crit@ci.ventura.ca.us" -AutomateProcessing AutoAccept

Get-CalendarProcessing "crit@ci.ventura.ca.us" | Format-List

Set-CalendarProcessing "crit@ci.ventura.ca.us" -AddOrganizerToSubject $True -DeleteComments $False -DeleteSubject $False

Get-MailBox "crit@ci.ventura.ca.us" | Set-CalendarProcessing -BookingWindowInDays 365
