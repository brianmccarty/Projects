$psScriptName = "ping.ps1"
$psScriptAuth = "Kahuna at PoshTips.com"
$psScriptDate = "11/12/2009"
$script:qMode = -1
##############################################################################
## Ping.ps1 - powershell script to ping systems
##
## Original Script by Kahuna at PoshTips.com - 11/12/2009
##
## Maintenance:
## Date        By   Comments
## ----------  ---  ----------------------------------------------------------
## 11/12/2009  KPS  New Script
##
##############################################################################
$scriptUsage = @"
Purpose:
    This script will retrieve a quick (one ping) network response
 
Usage:
    ./ping server hostlist.txt [-SHOW=ALL|FAIL|SUCCESS][-Q][-?|-H]
 
Where:
    -SHOW=ALL            displays all ping results (default)
    -SHOW=FAIL           displays only failed ping results
    -SHOW=SUCCESS        displays only successful ping results
    -V                   verbose mode (produce output of timestamps and script info)
    -? or -H             displays this help
 
Comments:
    From the PowerShell command-line, invoke the script, passing any combination
    of hostnames and filenames (text file(s) containing a hostname listing
    Any combinations and number of arguments can be used
    if an argument is a filename:
        each line in the file will processed as a hostname
        any lines starting with `"#`" will be treated as comments and ignored
    if an argument is not a filename:
        the argument will processed as a hostname
 
Example:
     ./ping server1 hostlist.txt server2 server3 -SHOW=FAIL
"@
 
##############################################################################
Set-PSDebug -Trace 0
 
$script:recCount = 0
$script:paramSHOW = "ALL"
 
function ShowScriptInfo() {
    "########################################################"
    [string]::Format("## PowerShell Script : {0}", $psScriptName)
    [string]::Format("## Written By        : {0}", $psScriptAuth)
    [string]::Format("## Last Updated on   : {0}", $psScriptDate)
    "########################################################"
    }	
 
function TimeStamp([string]$message) {
    "########################################################"
    "## $(Get-Date) $($message)"
    "########################################################"
    }
 
function ShowUsage(){
    ShowScriptInfo
    $scriptUsage
    }   
 
function WMIDateStringToDate($Bootup) {
    [System.Management.ManagementDateTimeconverter]::ToDateTime($Bootup)
    }
 
function DoPing ([string]$hostname){
    $erroractionpreference = "SilentlyContinue"
    $hostname = $hostname.trimend(".")
 
    $fqdn = [System.Net.Dns]::GetHostEntry($hostname).HostName
 
    $ping = new-object System.Net.NetworkInformation.Ping
    $reply = $ping.send($hostname)
    if ($reply.status -eq "Success"){
        [string]::Format("OK,{0},{2}",$reply.Address.ToString(),$reply.RoundtripTime,$fqdn)
        }
    else{
        $z = [system.net.dns]::gethostaddresses($hostname)[0].ipaddresstostring
        [string]::Format("FAIL,{0},{2}",$z,"***",$fqdn)
        }
    }
 
######################################################
## MAIN
######################################################
##
## Process command-line arguments
##
if ($args.count) {
 
    # Check for command-line flags
    foreach ($item in $args) {
        #$item
        if ($item.toupper() -like "-SHOW=*"){
            $x = $item.toupper()
            $paramShow = $x.replace("-SHOW=","")
            if (!(($paramShow -eq "ALL") -OR ($paramShow -eq "SUCCESS") -OR ($paramShow -eq "FAIL"))){
                ShowUsage
                exit
                }
            }
        if (($item.toupper() -eq "-H") -or ($item.toupper() -eq "-?")){
            ShowUsage
            exit
            }
        if ($item.toupper() -eq "-V") {$qMode = 0}
 
        }
 
if ($args.count){
    if (!($qMode)){
        ShowScriptInfo
        TimeStamp("SCRIPT STARTED")
        }
 
    "LN,HostName,PingStatus,IP,FQDN"
 
    # Loop through each argument
    foreach ($item in $args) {
        if ((!($item.Contains("SHOW=")) -AND (!($item.toupper() -eq "-Q")))) {
        #
        # if argument is a filename, process the contents of the file, ignoring any comment lines
        #
        if (test-path($item)) {
            if (!($qMode)) {[string]::Format("##`n## Processing contents of file: '{0}'`n##",$item)}
            foreach ($hostname in get-content $item) {
                $hostname = $hostname.trim()
                if (($hostname -notlike "#*") -and ($hostname -notlike "")) {
                    $recCount += 1
                    $d1 = DoPing($hostname)
                    if (($paramSHOW -eq "ALL") -or
                    (($paramSHOW -eq "FAIL") -and ($d1 -like "FAIL*")) -or
                    (($paramSHOW -eq "SUCCESS") -and ($d1 -like "OK*"))) {
                        [string]::Format("{3},{0},{1}{2}", $hostname,$d1,"",$recCount)
                        }
                    }
                }
            if (!($qMode)) {[string]::Format("##`n## End of file: '{0}'`n##",$item)}
            }
        #
        # if argument is NOT a filename, treat the argument as a hostname
        #
        else {
            $recCount += 1
            $d1 = DoPing($item)
            if (($paramSHOW -eq "ALL") -or
            (($paramSHOW -eq "FAIL") -and ($d1 -like "FAIL*")) -or
            (($paramSHOW -eq "SUCCESS") -and ($d1 -like "OK*"))) {
                [string]::Format("{3},{0},{1}{2}", $item,$d1,"",$recCount)
                }
            }
        }
        }
    }
    }
if (!($qMode)) {
    TimeStamp("SCRIPT ENDED")
    }
exit