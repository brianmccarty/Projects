Connect-MsolService

#cov@cityofventura.onmicrosoft.com
#w7zDxz12GTY

Get-MsolUser -ReturnDeletedUsers

Get-MsolUser -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin


Get-MsolUser -ReturnDeletedUsers | Format-List UserPrincipalName,ObjectID