<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Get-MDFSize
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]$Computer

    )

    Begin {}

    Process
    {
     [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null
        $s = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $Computer
        $dbs=$s.Databases

        foreach ($db in $dbs)
        {
            $dbname = $db.Name
            $filegroups = $db.filegroups
    
  
            foreach ($fg in $filegroups)
            {
                $mdfInfo = $fg.Files | Select Name, FileName, size, UsedSpace

                $mdfprops = @{
                           'Database'=$dbname;
                           'FileName'=$mdfInfo.filename;
                           'Size(MB)'=("{0:N4}" -f($mdfInfo.size/1MB));
                           'Used Space(MB)'=("{0:N4}" -f($mdfInfo.usedspace/1MB));
                          }
                $mdfobj = New-Object –typename PSObject -Property $mdfprops

                Write-Output $mdfobj
            }  
    
        }
    }
    End {}
}