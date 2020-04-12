function Get-GroupMember
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]$Groupname
    )

    Begin{}

    Process{
        foreach ($group in $groupname){
        $member = Get-ADGroupMember -Identity $group | select name |sort name
        
        Write-output '------------------'
        Write-output $group
        Write-output '------------------'
        Write-output $member
        Write-Output "`n"
        }
    }

    End{}    
}