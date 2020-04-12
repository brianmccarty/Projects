[CmdletBinding()]
param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
    [string[]]$Computername,

    [Parameter(Mandatory=$True)]
    [string[]]$OutputPath

    )

BEGIN {
    if(Test-Path $OutputPath){
        # exists
    } else {
        mkdir $OutputPath | Out-Null
    }

    $css = @"

    body {
        font-family:Tahoma;
        font-size:10pt;
        font-weight: normal;
        background-color:white;
        margin-left:auto;
        margin-right:auto;
        width:50%;
    }

    p {
        margin-bottom: 2px;
        margin-top: 2px;
        margin-left: 2px;
    }

    th {
        font-weight:bold;
        color:white;
        background-color:#3D97FF;
    }

    td {
        width:25%;
    }

    h1 {
        color:#0074FF;
        border-bottom: 2px solid #0074FF;
        padding:5px;
        width:100%;
    }
    h2 {
        border-bottom: 2px solid #0074FF;
        margin-bottom:4px;
        color:#0074FF;
        padding:3px;
        width:100%;
        text-align:left;
        font-size:13pt;
    }

    .even { background-color:#F2F2F2; }
    .odd { background-color:#D8D8D8; }
    .dataTables_length { padding:6px; }
    .dataTables_filter { padding:6px; }

    .paginate_disabled_previous,
    .paginate_disabled_next {
        padding:4px;
        font-size:10pt;
        color:#ddd;
    }

    .paginate_enalbed_previous,
    .paginate_enabled_next {
        padding:4px;
        font-size:10pt;
        color:blue;
        cursor:pointer;
    }

    table.TABLEFRAG { 
        width:100%; 
    }

"@
}#end Begin
PROCESS {
    Foreach ($Computer in $Computername) {
        Write-Verbose -Message "$computer - Gathering System Details..."
        $cs = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computer
        $bios = Get-WmiObject -Class Win32_BIOS -ComputerName $computer
        $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer

        $props1=[ordered]@{
                        'ComputerName'=$computer;
                        'User'=$cs.username;
                        'Version'=$os.caption;
                        'Architecture'=$os.osarchitecture;
                        'Service Pack'=$os.servicepackmajorversion;
                        'Memory(GB)'=$cs.totalphysicalmemory / 1gb -as [int];
                        'Logical Processors'=$cs.numberoflogicalprocessors;
                        'Manufacturer'=$cs.manufacturer;
                        'BIOS Serial'=$bios.serialnumber;
                        }
            
        $sysobj = New-Object –typename PSObject -Property $props1      
        
        $frag1 = $sysobj | ConvertTo-EnhancedHTMLFragment -TableCssID SYSTABLE `
                                                -DivCssID SYSDIV `
                                                -DivCssClass WHATEVER `
                                                -TableCssClass TABLEFRAG `
                                                -As List `
                                                -EvenRowCssClass 'even' `
                                                -OddRowCssClass 'odd' `
                                                -PreContent '<h2>System Details</h2>' |
                 Out-String

        #Get Disk Info
        Write-Verbose -Message "$computer - Gathering Disk Details..."

        Write-Verbose -Message "ComputerName: $Computer - Getting Disk(s) information..."
            try {
                # Set all the parameters required for our query
                $params = @{'ComputerName'=$Computer;
                            'Class'='Win32_LogicalDisk';
                            'Filter'="DriveType=3";
                            'ErrorAction'='SilentlyContinue'}
                $TryIsOK = $True
                
                # Run the query against the current $Computer    
                $Disks = Get-WmiObject @params
            }#Try
            
            Catch {
                "$Computer" | Out-File -Append -FilePath c:\Errors.txt
                $TryIsOK = $False
            }#Catch
            
            if ($TryIsOK) {
                Write-Verbose -Message "ComputerName: $Computer - Formating information for each disk(s)"
                foreach ($disk in $Disks) {
                    
                    # Prepare the Information output
                    Write-Verbose -Message "ComputerName: $Computer - $($Disk.deviceid)"
                    $output =         @{'ComputerName'=$computer;
                                    'Drive'=$disk.deviceid;
                                    'FreeSpace(GB)'=("{0:N2}" -f($disk.freespace/1GB));
                                    'Size(GB)'=("{0:N2}" -f($disk.size/1GB));
                                    'PercentFree'=("{0:P2}" -f(($disk.Freespace/1GB) / ($disk.Size/1GB)))}
                    
                    # Create a new PowerShell object for the output
                    $object = New-Object -TypeName PSObject -Property $output
                    $object.PSObject.TypeNames.Insert(0,'Report.DiskSizeInfo')
                    
                    }#foreach ($disk in $Disks)

            $Disk = $object | ConvertTo-EnhancedHTMLFragment -TableCssID DISKTABLE `
                                                -DivCssID DISKDIV `
                                                -DivCssClass DISK `
                                                -TableCssClass TABLEFRAG `
                                                -As Table `
                                                -Properties * `
                                                -EvenRowCssClass 'even' `
                                                -OddRowCssClass 'odd' `
                                                -PreContent '<h2>Disk Details</h2>' |
                 Out-String
        
        #Get Last Boot Up Time
        Write-Verbose -Message "$computer - Getting boot time..."
        $Boot = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer |  Select @{ N= "Last Restarted On" ; E= { $_.Converttodatetime( $_.LastBootUpTime ) } } |
                 ConvertTo-EnhancedHTMLFragment -TableCssID BOOTTABLE `
                                                -DivCssID BOOTDIV `
                                                -DivCssClass BOOT `
                                                -TableCssClass TABLEFRAG `
                                                -As List `
                                                -Properties * `
                                                -EvenRowCssClass 'even' `
                                                -OddRowCssClass 'odd' `
                                                -PreContent '<h2>Boot Time</h2>' |
                 Out-String

        #Get Windows Update last run information.
        $key = “SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\Results\Install” 
        $keytype = [Microsoft.Win32.RegistryHive]::LocalMachine 
        $RemoteBase = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($keytype,$Computer) 
        $regKey = $RemoteBase.OpenSubKey($key) 
                
        $prop = @{
                    'Last Update'=$regkey.GetValue("LastSuccessTime");
                    }
        
        $obj = New-Object –typename PSObject -Property $prop  

        $Update = $obj | ConvertTo-EnhancedHTMLFragment -TableCssID SVCTABLE `
                                                -DivCssID SVCDIV `
                                                -DivCssClass UPDATE `
                                                -TableCssClass TABLEFRAG `
                                                -As List `
                                                -Properties * `
                                                -EvenRowCssClass 'even' `
                                                -OddRowCssClass 'odd' `
                                                -PreContent '<h2>Windows Update</h2>' |
                 Out-String

        #Get Services Information
        $Service = Get-WmiObject -Class Win32_Service -ComputerName $Computer |  Where-Object { ($_.StartMode -eq "Auto") -and ($_.State -eq "Stopped") } |  Select DisplayName,Name,StartMode,State,Description  |
                 ConvertTo-EnhancedHTMLFragment -TableCssID SVCTABLE `
                                                -DivCssID SVCDIV `
                                                -DivCssClass SERVICES `
                                                -TableCssClass TABLEFRAG `
                                                -As Table `
                                                -Properties * `
                                                -EvenRowCssClass 'even' `
                                                -OddRowCssClass 'odd' `
                                                -PreContent '<h2>Stopped Services</h2><p>Services that are set to Automatic which are Stopped.</p>' |
                 Out-String

        #Get NIC Information
        $network = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $Computer -Filter "IPEnabled=True" -Property DNSDomain,DHCPEnabled,IPAddress,DefaultIPGateway,Description,DNSServerSearchOrder | select DNSDomain,DHCPEnabled,IPAddress,DefaultIPGateway,Description,DNSServerSearchOrder |
                 ConvertTo-EnhancedHTMLFragment -TableCssID NETTABLE `
                                                -DivCssID NETDIV `
                                                -DivCssClass NETWORK `
                                                -TableCssClass TABLEFRAG `
                                                -As Table `
                                                -Properties * `
                                                -EvenRowCssClass 'even' `
                                                -OddRowCssClass 'odd' `
                                                -PreContent '<h2>Network</h2>' |
                 Out-String

        $Path = Join-Path -Path $OutputPath -ChildPath "$computer.html"
        Write-Verbose "Writing report for $computer to $path"
                                    

        ConvertTo-EnhancedHTML -HTMLFragments $frag1,$Boot,$Update,$Disk,$Network,$Service `
                               -Title "System Report for $Computer" `
                               -PreContent "<h1>System Report for $Computer</h1>Retreived $(Get-Date)" `
                               -PostContent "<br /><br /><hr />" `
                               -CssStyleSheet $css |

        Out-File $Path
        }
    }#foreach
}#process

END {}                       


                       