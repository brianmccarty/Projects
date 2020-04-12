$a =  @{Expression={$_.UserPrincipalName};Label="Source UPN"}, `
      @{Expression={$_.SamAccountName};Label="Source SAM Account Name"}, `
      @{Expression={$_.emailaddress};Label="Source Email Address"}

get-aduser –filter * -Properties * | select $a | export-csv -path "cpisolutions_skykick.csv" –notypeinformation 