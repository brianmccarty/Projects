<#
.Synopsis
   Sets the DNS server address of local and remote servers.

.DESCRIPTION
   Export the DNS server addresses of local and remote computers

.EXAMPLE
   Get DNS servers for local computer
   
   Get-DNSServerAddress

.EXAMPLE
   Store your credentials in the $cred variable
   Get-DNSServerAddress -ComputerName Server1 -Credentials $cred
#>
function Get-DNSServerAddress
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Low')]
    
    [Alias()]
    [OutputType([String])]
    Param
    (
        [parameter(
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [string[]]$ComputerName = $env:COMPUTERNAME,
        
        [parameter(Position=1)]
        [System.Management.Automation.PSCredential]
        $Credential      
    )

    Begin{
    }

    Process{
            $WMI = @{
            Class = 'Win32_NetworkAdapterConfiguration'
            Filter = "IPEnabled = 'true'"
            ComputerName = $ComputerName
            }
       
        if ($Credential -ne $Null){
            $WMI.Credential = $Credential
            }       
        
        foreach ($adapter in (Get-WmiObject @WMI)){
            $props = @{
                Server = $adapter.DNSHostName
                'DNS Servers' = $adapter.DNSServerSearchOrder
            }
        
        New-Object PSObject -Property $props


        }#foreach
       
    }#Process
    
    End{
    }
}