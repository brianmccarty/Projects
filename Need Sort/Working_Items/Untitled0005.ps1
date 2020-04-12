BREAK

Get-OwaVirtualDirectory | Set-OwaVirtualDirectory -SetPhotoEnabled $False

Get-OWAMailboxPolicy | Set-OWAMailboxPolicy -SetPhotoEnabled $False Set-CASMailbox nuno -OWAMailboxPolicy Default