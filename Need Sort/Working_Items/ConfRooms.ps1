# Get user login Credentials for Office 365
$UserCredential = Get-Credential

# Setup Session to Office 365
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

# Start Office 365 Session
Import-PSSession $Session

# Import CSVs into variable  
$psupns = Import-Csv -Path C:\tmp\pscrooms.csv
$ciupns = Import-Csv -Path C:\tmp\cicrooms.csv

# Loop through CSV and update users if the exist in CVS file and update to Room and set calendar options

foreach ($psupn in $psupns) {
    Set-mailbox '$($psupn.userprincipalname)' -Type Room

    Set-CalendarProcessing '$($psupn.userprincipalname)' -AutomateProcessing AutoAccept

    Set-CalendarProcessing '$($psupn.userprincipalname)' -AddOrganizerToSubject $True -DeleteComments $False -DeleteSubject $False

    Get-MailBox '$($psupn.userprincipalname)' | Set-CalendarProcessing -BookingWindowInDays 365
}

foreach ($ciupn in $ciupns) {
    Set-mailbox '$($ciupn.userprincipalname)' -Type Room

    Set-CalendarProcessing '$($ciupn.userprincipalname)' -AutomateProcessing AutoAccept

    Set-CalendarProcessing '$($ciupn.userprincipalname)' -AddOrganizerToSubject $True -DeleteComments $False -DeleteSubject $False

    Get-MailBox '$($ciupn.userprincipalname)' | Set-CalendarProcessing -BookingWindowInDays 365
}

# End Office 365 Session for clean log off
# Remove-PSSession $Session