[PS] C:\Windows\system32>history

  Id CommandLine
  -- -----------
   1 . 'C:\Program Files\Microsoft\Exchange Server\V14\bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto
   2 Get-MailboxDatabase | ft name,publicfolderdatabase
   3 Get-PublicFolderItemStatistics
   4 Get-PublicFolderItemStatistics -Identity "\calendars"
   5 Get-PublicFolderItemStatistics -Identity "\contacts"
   6 Get-PublicFolder -Identity "\calendars"
   7 Get-PublicFolder -Identity *
   8 Get-PublicFolder -Server tlcexhcnage
   9 Get-PublicFolder
  10 Remove-PublicFolder -Identity "\calendars"
  11 clear
  12 Get-PublicFolder -Identity *
  13 Get-PublicFolder -filter *
  14 Get-PublicFolder -Identity *
  15 Get-PublicFolderItemStatistics -Identity "\contacts"
  16 Get-PublicFolderItemStatistics -Identity "\contacts" -Recurse: $True
  17 Get-PublicFolderItemStatistics -Identity "\contacts\Regal Email Addresses"
  18 clear
  19 Get-PublicFolderItemStatistics -Identity "\contacts" -Recurse: $True
  20 clear
  21 Get-PublicFolderItemStatistics -Identity "\contacts"
  22 Get-PublicFolderItemStatistics -Identity "\contacts\Regal Email Addresses"
  23 Get-PublicFolder -Server tlcexchange "\" -Recurse -ResultSize:Unlimited
  24 Get-PublicFolder -Server tlcexhcnage "\Non_Ipm_Subtree" -Recurse -ResultSize:Unlimited
  25 Get-PublicFolder -Server tlcexchange "\Non_Ipm_Subtree" -Recurse -ResultSize:Unlimited
  26 Get-MailboxDatabase | fl
  27 Get-MailboxDatabase | fl name,publicfolderdatabase
  28 Set-MailboxDatabase -PublicFolderDatabase $null
  29 Get-MailboxDatabase | fl name,publicfolderdatabase
  30 Get-MailboxDatabase | fl name,publicfolderdatabase
  31 Get-MailboxDatabase | fl name,publicfolderdatabase
  32 Get-MailboxDatabase | fl name,publicfolderdatabase
