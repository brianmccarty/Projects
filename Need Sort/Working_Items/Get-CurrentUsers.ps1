<#
.SYNOPSIS
    Searched for stale user accounts in AD.

.DESCRIPTION
    This function finds active user accounts that have not logged on `
    in a given amount of time.

.EXAMPLE
    Get-OldUsers -Days 90

.PARAMETER Days
    The number of days old.

#>
function Get-CurrentUsers {

  [CmdletBinding()]
    Param (
    [Parameter(Mandatory=$True,Position=1)]
    [int]$Days
    )

Begin { $Date = (Get-Date).AddDays(-$Days) }

Process { 
    $Process = Get-AdUser -Filter { (LastLogonDate -ge $Date) -and (enabled -eq $True) -and (ObjectClass -eq 'user') }`
               -Properties LastLogonDate

     }

End {  $process
 }

}