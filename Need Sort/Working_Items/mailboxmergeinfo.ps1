$Report = @() 

$mailbox = Get-Mailbox -ResultSize unlimited

$mailbox| ForEach-Object{

    $EXAlias = $_.Alias
    $ExchangeGuid = $_.ExchangeGuid
    $UserPrincipalName = $_.UserPrincipalName
    $Database = $_.Database
    $ForwardingAddress = $_.ForwardingAddress
    $ForwardingSmtpAddress = $_.ForwardingSmtpAddress
    $EmailAddresses = [string]($_.EmailAddresses |% {$_.addressstring})
    $IsMailboxEnabled = $_.IsMailboxEnabled
    $RecipientTypeDetails = $_.RecipientTypeDetails
    $PrimarySmtpAddress = $_.PrimarySmtpAddress 
    $DisplayName = $_.DisplayName
    $TotalItemSize = (Get-MailboxStatistics -Identity $DisplayName ).TotalItemSize.Value.ToMB()
    $MailboxGuid = (Get-MailboxStatistics -Identity $DisplayName ).MailboxGuid
    $DatabaseName = (Get-MailboxStatistics -Identity $DisplayName ).DatabaseName
    $ItemCount = (Get-MailboxStatistics -Identity $DisplayName ).ItemCount
    $LastLogonTime = (Get-MailboxStatistics -Identity $DisplayName ).LastLogonTime
    $LastLogoffTime = (Get-MailboxStatistics -Identity $DisplayName ).LastLogoffTime
    $LastLoggedOnUserAccount = (Get-MailboxStatistics -Identity $DisplayName ).LastLoggedOnUserAccount
    $obj = New-Object System.Object
    $obj | Add-Member -MemberType NoteProperty -Name "ExchangeAlias" -Value $EXAlias
    $obj | Add-Member -MemberType NoteProperty -Name "ExchangeGuid" -Value $ExchangeGuid
    $obj | Add-Member -MemberType NoteProperty -Name "UserPrincipalName" -Value $UserPrincipalName
    $obj | Add-Member -MemberType NoteProperty -Name "Database" -Value $Database
    $obj | Add-Member -MemberType NoteProperty -Name "ForwardingAddress" -Value $ForwardingAddress
    $obj | Add-Member -MemberType NoteProperty -Name "EmailAddresses" -Value $EmailAddresses
    $obj | Add-Member -MemberType NoteProperty -Name "IsMailboxEnabled" -Value $IsMailboxEnabled
    $obj | Add-Member -MemberType NoteProperty -Name "RecipientTypeDetails" -Value $RecipientTypeDetails
    $obj | Add-Member -MemberType NoteProperty -Name "PrimarySmtpAddress" -Value $PrimarySmtpAddress
    $obj | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $DisplayName
    $obj | Add-Member -MemberType NoteProperty -Name "TotalItemSizeMB" -value $TotalItemSize
    $obj | Add-Member -MemberType NoteProperty -Name "MailboxGuid" -Value $MailboxGuid
    $obj | Add-Member -MemberType NoteProperty -Name "DatabaseName" -Value $DatabaseName
    $obj | Add-Member -MemberType NoteProperty -Name "ItemCount" -value $ItemCount
    $obj | Add-Member -MemberType NoteProperty -Name "LastLogonTime" -value $LastLogonTime
    $obj | Add-Member -MemberType NoteProperty -Name "LastLogoffTime" -value $LastLogoffTime
    $obj | add-member -MemberType NoteProperty -Name "LastLoggedOnUserAccount" -value $LastLoggedOnUserAccount
    $Report += $obj
}

$Report | Export-Csv c:\temp\report.csv -NoTypeInformation