$NeedsNew = get-mailbox -ResultSize Unlimited
foreach ( $Mailbox in $NeedsNew ) {
    $NewAddress = $($Mailbox.alias + "@sunroad.mail.onmicrosoft.com")
    $NewAddress
    Set-Mailbox -Identity $Mailbox -EmailAddresses @{Add=$NewAddress}
} 