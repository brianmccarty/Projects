
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
function Get-LDFSize
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
            $filegroups = $db.logfiles
  
            foreach ($fg in $filegroups)
            {
                $ldfInfo = $fg | Select Name, FileName, size, UsedSpace

                $ldfprops = @{
                           'Database'=$dbname;
                           'FileName'=$ldfInfo.filename;
                           'Size(MB)'=("{0:N4}" -f($ldfInfo.size/1MB));
                           'Used Space(MB)'=("{0:N4}" -f($ldfInfo.usedspace/1MB));
                          }
                $ldfobj = New-Object –typename PSObject -Property $ldfprops

                Write-Output $ldfobj
             }  
    
        }
    }

    End {}

}