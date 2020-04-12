$users = Import-Csv c:\temp\newusers.csv

$OU = "OU=Imported,DC=nlacrc,DC=org"

foreach($user in $users)
{

    $props = @{}
    $propNames = $user | Get-Member -MemberType properties | %{$_.name}
    foreach($prop in $propNames)
    {
        $value = $user.$prop -replace "'|`"",""
        $props += @{$prop=$value}
    }
    $MyUser = new-qaduser -name $user.displayName -ObjectAttributes $props -parent $OU -verb -ea 0
}