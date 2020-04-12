BREAK

Get-PublicFolder -Server tlcexchange "\" -Recurse -ResultSize:Unlimited

Get-PublicFolder -Server tlcexchange "\" -Recurse -ResultSize:Unlimited | Remove-PublicFolder -Server tlcexchange -Recurse -ErrorAction:SilentlyContinue

Get-PublicFolder -Server tlcexhcnage "\Non_Ipm_Subtree" -Recurse -ResultSize:Unlimited | Remove-PublicFolder -Server tlcexchange -Recurse -ErrorAction:SilentlyContinue