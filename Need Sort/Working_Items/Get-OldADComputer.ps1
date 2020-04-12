<#
.SYNOPSIS
    Retreives last logon date for ad computer.

.DESCRIPTION
    This function searches for computer in Active Directory who's last logon is older than a specified date.
    Pipe this to Remove-ADComputer remove old comptuers.

.EXAMPLE
    Get-OldADComputer -Days 90

.EXAMPLE
    Get-OldADComputer -Days 90 | where {$_.enabled -eq $false}

    This get computers that have not logged on in 90 day and are disabled.

.PARAMETER Days
    The number of days old.

#>
function Get-OldADComputer {

  [CmdletBinding()]
    Param (
    [Parameter(Mandatory=$True,Position=1)]
    [int]$Days
    )

Begin { $Date = (Get-Date).AddDays(-$Days) }

Process { 
        $process = Get-ADComputer -Filter {lastlogontimestamp -le $Date} -Properties lastlogontimestamp |`
        select Name,@{label="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}},Enabled

        Write-Output $process
       
}

End { }

}