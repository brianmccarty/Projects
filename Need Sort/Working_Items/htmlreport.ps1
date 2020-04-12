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
}
PROCESS {
    Foreach ($Computer in $Computername) {
        $OS = Get-OSInfo -ComputerName $Computer | 
                 ConvertTo-EnhancedHTMLFragment -TableCssID SYSTABLE `
                                                -DivCssID SYSDIV `
                                                -DivCssClass WHATEVER `
                                                -TableCssClass TABLEFRAG `
                                                -As List `
                                                -Properties * `
                                                -EvenRowCssClass 'even' `
                                                -OddRowCssClass 'odd' `
                                                -PreContent '<h2>System Details</h2>' |
                 Out-String

        $Disk = Get-DiskSizeInfo -ComputerName $Computer | 
                 ConvertTo-EnhancedHTMLFragment -TableCssID DISKTABLE `
                                                -DivCssID DISKDIV `
                                                -DivCssClass DISK `
                                                -TableCssClass TABLEFRAG `
                                                -As Table `
                                                -Properties * `
                                                -EvenRowCssClass 'even' `
                                                -OddRowCssClass 'odd' `
                                                -PreContent '<h2>Disk Details</h2>' |
                 Out-String

        $Boot = Get-WmiObject -Class Win32_OperatingSystem -ComputerName cpi-0605 |  Select @{ N= "Last Restarted On" ; E= { $_.Converttodatetime( $_.LastBootUpTime ) } } |
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

        $Update = Get-OSLastUpdate -ComputerName $Computer | ConvertTo-EnhancedHTMLFragment -TableCssID SVCTABLE `
                                                -DivCssID SVCDIV `
                                                -DivCssClass UPDATE `
                                                -TableCssClass TABLEFRAG `
                                                -As List `
                                                -Properties * `
                                                -EvenRowCssClass 'even' `
                                                -OddRowCssClass 'odd' `
                                                -PreContent '<h2>Windows Update</h2>' |
                 Out-String

        $Service = Get-WmiObject -Class Win32_Service -ComputerName $Computer |  Where-Object { ($_.StartMode -eq "Auto") -and ($_.State -eq "Stopped") } |  Select-Object SystemName, DisplayName, Name, StartMode, State, Description  |
                 ConvertTo-EnhancedHTMLFragment -TableCssID SVCTABLE `
                                                -DivCssID SVCDIV `
                                                -DivCssClass SERVICES `
                                                -TableCssClass TABLEFRAG `
                                                -As Table `
                                                -Properties * `
                                                -EvenRowCssClass 'even' `
                                                -OddRowCssClass 'odd' `
                                                -MakeHiddenSection `
                                                -PreContent '<h2>Stopped Services</h2>' |
                 Out-String

        $network = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $Computer -Filter "IPEnabled=True" | select DNSDomain,DHCPEnabled,IPAddress,DefaultIPGateway,Description |
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
                                    

        ConvertTo-EnhancedHTML -HTMLFragments $OS,$Boot,$Update,$Disk,$Network,$Service `
                               -Title "System Report for $Computer" `
                               -PreContent "<h1>System Report for $Computer</h1>Retreived $(Get-Date)" `
                               -PostContent "<br /><br /><hr />" `
                               -CssStyleSheet $css |

        Out-File $Path
    }#foreach
}#process
END {}                       


                       