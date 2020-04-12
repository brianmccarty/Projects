Function Set-Profile 
{ 
 psedit $profile 
} #end function set-profile 
 
Function Add-Help 
{ 
  <# 
   .Synopsis 
    This function adds help at current insertion point  
   .Example 
    add-help 
    adds comment based help at current insertion point  
   .Notes 
    NAME:  Add-Help 
    AUTHOR: ed wilson, msft 
    LASTEDIT: 09/07/2010 17:32:34 
    HSG: WES-09-11-10 
    KEYWORDS: Scripting Techniques, Windows PowerShell ISE 
   .Link 
     Http://www.ScriptingGuys.com 
 #Requires -Version 2.0 
 #> 
 $helpText = @" 
 <# 
   .Synopsis 
    This does that  
   .Description 
    This function does 
   .Example 
    Example- 
    Example- accomplishes  
   .Parameter  
    The parameter 
   .Notes 
    NAME:  Example- 
    AUTHOR: ed wilson, msft 
    LASTEDIT: $(Get-Date) 
    KEYWORDS: 
    HSG:  
   .Link 
     Http://www.ScriptingGuys.com 
 #Requires -Version 2.0 
 #> 
"@ 
 $psise.CurrentFile.Editor.InsertText($helpText) 
} #end function add-help 
 
Function Add-HeaderToScript 
{ 
  <# 
   .Synopsis 
    This function adds header information to a script  
   .Example 
    Add-HeaderToScript 
    Adds header comments to script  
   .Example  
    AH 
    Uses alias to add header comments to script 
   .Notes 
    NAME:  Add-HeaderToScript 
    AUTHOR: ed wilson, msft 
    LASTEDIT: 09/07/2010 19:37:28 
    KEYWORDS: Scripting Techniques, Windows PowerShell ISE 
    HSG: WES-09-12-10 
   .Link 
     Http://www.ScriptingGuys.com 
 #Requires -Version 2.0 
 #> 
 $header = @" 
# ----------------------------------------------------------------------------- 
# Script: $(split-path -Path $psISE.CurrentFile.FullPath -Leaf) 
# Author: ed wilson, msft 
# Date: $(Get-Date) 
# Keywords: 
# comments: 
# 
# ----------------------------------------------------------------------------- 
"@ 
 $psise.CurrentFile.Editor.InsertText($header) 
} #end function add-headertoscript 
 
# I use Get-logNameFromDate and Start-iseTranscript together. Get-logNameFromDate  
# is called from Start-iseTranscript 
 
Function Get-logNameFromDate 
{ 
  <# 
   .Synopsis 
    Creates a log name from date 
   .Description 
    This script creates a log from a date.  
   .Example 
    Get-logNameFromDate -path "c:\fso" -name "log" 
    Creates a file name like c:\fso\log20100914-122019.Txt but does not 
    create the file. It returns the file name to calling code. 
   .Example 
    Get-logNameFromDate -path "c:\fso" -name "log" -Create 
    Creates a file name like c:\fso\log20100914-122019.Txt and 
    create the file. It returns the file name to calling code. 
   .Parameter path 
    path to log file 
   .Parameter name 
    base name of log file 
   .Parameter create 
    switch that determines whether log file or only name is created 
   .inputs 
    [string] 
   .outputs 
    [string] 
   .Notes 
    NAME:  Get-LogNameFromDate 
    AUTHOR: ed wilson, msft 
    LASTEDIT: 09/10/2010 16:58:06 
    KEYWORDS: parameter substitution, format specifier, string substitution 
    HSG: WES-09-25-10 
   .Link 
     Http://www.ScriptingGuys.com 
 #Requires -Version 2.0 
 #> 
 Param( 
  [string]$path = "c:\fso", 
  [string]$name = "log", 
  [switch]$Create 
 ) 
 $logname = "{0}\{1}{2}.{3}" -f $path,$name, ` 
    (Get-Date -Format yyyyMMdd-HHmmss),"Txt" 
 if($create)  
  {  
   New-Item -Path $logname -ItemType file | out-null 
   $logname 
  } 
 else {$logname} 
} # end function get-lognamefromdate 
 
Function Start-iseTranscript 
{ 
  <# 
   .Synopsis 
    This captures output from a script to a created text file 
   .Example 
    Start-iseTranscript -logname "c:\fso\log.txt" 
    Copies output from script to file named xxxxlog.txt in c:\fso folder 
   .Parameter logname 
    the name and path of the log file. 
   .inputs 
    [string] 
   .outputs 
    [io.file] 
   .Notes 
    NAME:  Start-iseTranscript 
    AUTHOR: ed wilson, msft 
    LASTEDIT: 09/10/2010 17:27:22 
    KEYWORDS: 
    HSG: WES-09-25-10 
   .Link 
     Http://www.ScriptingGuys.com 
 #Requires -Version 2.0 
 #> 
  Param( 
   [string]$logname = (Get-logNameFromDate -path "C:\fso" -name "log" -Create) 
  ) 
  $transcriptHeader = @" 
************************************** 
Windows PowerShell ISE Transcript Start 
Start Time: $(get-date) 
UserName: $env:username 
UserDomain: $env:USERDNSDOMAIN 
ComputerName: $env:COMPUTERNAME 
Windows version: $((Get-WmiObject win32_operatingsystem).version) 
************************************** 
Transcript started. Output file is $logname 
"@ 
 $transcriptHeader >> $logname 
 $psISE.CurrentPowerShellTab.Output.Text >> $logname 
} #end function start-iseTranscript 
 
Function backUp-Profile() 
{ 
 Param([string]$destination = "C:\trans\backup") 
 $dte = get-date 
 $buName = $dte.tostring() -replace "[\s:{/}]","_" 
 $buName = $buName + "_Profile" 
 copy-item -path $profile -destination "$destination\ISE$buName.ps1" 
} #end backup-Profile 
 
# *** Alias *** 
if(!(Test-Path alias:ah)) 
 { 
  New-Alias -Name ah -Value add-headertoscript -Description "MrEd alias" | 
  Out-Null 
  } 
 
# *** Variables *** 
if(!(Test-Path variable:moduleHome)) 
{ 
 new-variable -name moduleHome -value "$env:userProfile\documents\WindowsPowerShell\Modules" 
} 
 
Export-ModuleMember -alias * -function * -variable *