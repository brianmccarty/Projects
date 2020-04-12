Summary: Microsoft premier field engineers share some of their favorite functions from their Windows PowerShell profiles.

Microsoft Scripting Guy, Ed Wilson, is here. Today we will look at some profile excerpts from a few Microsoft premier field engineers (PFEs).

Michael Wiley offers the following idea:

“I actually got this from Ashley McGlone, but I use it extensively for giving presentations and demos. My $Profile for ISE contains the following lines to make error text more readable on projectors and to increase the font size.”

# Make error text easier to read in the console pane.

$psISE.Options.ErrorBackgroundColor = “red”

$psISE.Options.ErrorForegroundColor = “white”

 

# Make text easier to read at larger resolutions

$psISE.Options.Zoom = 125

“And I use the following for the $Profile in console.”

$a = (Get-Host).PrivateData

$a.ErrorBackgroundColor = “red”

$a.ErrorForegroundColor = “white”

“I adjust the font setting on my console to 18pt Lucinda Console, and the Layout is 80 wide by 35 high. I also apply these same settings inside all of my virtual machines. On a typical 1024×768 projector, this makes the text very readable for students.”

Ashley McGlone (@GoateePFE) provided this additional tip:

“As part of my work, I teach many Windows PowerShell workshops for our customers. I’ve been using Windows PowerShell for four years, and I run a fairly minimal profile for both the console and the ISE. I do this for two reasons:

1. I am a purist, and I like things clean and simple.

2. I want to have a default environment when I am teaching students.

“Here is what I use in my console profile.”

# Clean out small files from my transcript folder

dir C:UsersasmcglonDocumentsPowerShell_Transcripts*.txt | ? length -lt 1kb | remove-item

# Log a transcript for every console session in case I need to go back and find a command later

Start-Transcript -Path “C:UsersashleyDocumentsPowerShell_Transcripts$(Get-Date -Format yyyyMMddHHmmss).txt” | Out-Null

# Set the console error colors to white text on red background.

# This is much easier to read on a projector.

$a = (Get-Host).PrivateData

$a.ErrorBackgroundColor = “red”

$a.ErrorForegroundColor = “white”

“Here is what I use in my ISE profile.”

# Make error text easier to read in the console pane.

$psISE.Options.ErrorBackgroundColor = “red”

$psISE.Options.ErrorForegroundColor = “white”

# Make text easier to read at larger resolutions

$psISE.Options.Zoom = 125

“That’s it. These very basic settings help me as I teach Windows PowerShell.”

Funtrol Ready says his main areas of focus are SharePoint and Windows PowerShell.

“I use a really basic profile that connects me to Office 365 where I can manage, demo, or troubleshoot the suite of products by using Windows PowerShell.

“In my ISE profile, first I capture my credentials and then connect to Office 365. This requires the installation of the Microsoft Online Services Sign-in Assistant and the Windows Azure Active Directory Module for Windows PowerShell. If I am using Windows PowerShell 2.0, I must import the module. Windows PowerShell 3.0 or later will automatically load them for me.”

$o365cred = get-credential -UserName admin@<my-tenant>.onmicrosoft.com -Message cloudO365demo

Connect-MsolService -Credential $o365cred

“Next I connect to SharePoint Online. This requires downloading the SharePoint Online Management Shell.”

connect-sposervice -url https://<my-tenant>-admin.sharepoint.com -Credential $o365cred

 “Next I connect to Lync Online. This requires the installation of the Lync Online Connector Module.”

Import-Module LyncOnlineConnector

$session = New-CsOnlineSession -Credential $o365cred

Import-PSSession $session

“And finally, I connect to Exchange Online by using a remote session.”

$exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $o365cred -Authentication “Basic” -AllowRedirection

Import-PSSession $exchangeSession

Georges Maheu says that he uses Windows PowerShell every day. Most of the time, he uses Windows PowerShell with scripts, but he uses the console to test things and to do research. Here are some of the functions from his profile.

“My first function loads my profile to facilitate editions. This is very useful when you are creating your profile. The second function pipes Help text to More, which reduces scrolling. The third function lists WMI classes (excluding CIM classes). The last function is my favorite, it overwrites the default Prompt function. This provides the following:

1. Displays a timestamp to gauge timespans between commands. I use Measure-Command for more precise timing, but this provides me with a rough order of magnitude.

2. Displays the current path on its own line, which provides more real estate to type commands.

3. The green color and ‘—‘ line provides a visual clue that separates commands.”

#————————————————————–

function profile  

{

notepad $profile

} #function profile

 

#————————————————————–

function moreHelp($what)

{

get-help -name $what -full | more

} #function moreHelp

 

#————————————————————–

function getWMI($what)

{

get-wmiobject -list |

  where-object {$_.name -match $what -and

         $_.name -notmatch “CIM_”}

} #function getWMI

 

#————————————————————–

function prompt()

{

Write-Host -ForegroundColor Green @”

PS $(get-date) $(Get-Location)

————————————————————–

“@

 

$(if ($nestedpromptlevel -ge 1) { ‘>>’ }) + ‘> ‘

} #function prompt()

 

# Initialise PowerShell =======================================

 

(get-host).UI.RawUI.windowTitle = “George’s PowerShell”

Ian Farr claims to be a PowerShell addict…

“There, I’ve said it! I also teach Windows PowerShell and help my customers with their scripts. I’ve got a lot in my $profile. Here’s some of the publishable stuff.

“I check to see whether the console has been started with ‘Run as Administrator.’ If it has, I give it a different color than that of my standard console, so I instantly know what context I’m in. I also kick off a background update of my Help files because this can only be achieved with admin permissions.”

#Check for admin privs

If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`

   [Security.Principal.WindowsBuiltInRole] “Administrator”))

{

 

  #Change the console display

  $UI = (Get-Host).UI.RawUI

  $UI.BackgroundColor = “blue”

  $UI.ForegroundColor = “white”

  $UI.WindowTitle = “Ian’s Admin PowerShell”

  Set-Location c:

  cls

 

  #Update Help files

  Start-Job -ScriptBlock {Update-Help -Force}

}

Else

{

  #Change the console display

  $UI = (Get-Host).UI.RawUI

  $Size = $UI.WindowSize

    $Size.Width = 120

    $Size.Height = 60

  $UI.WindowSize = $Size

  $UI.BackgroundColor = “black”

  $UI.ForegroundColor = “darkgreen”

  $UI.WindowTitle = “Ian’s PowerShell”

  cls

}

“The following function automatically adds –AutoSize for when I use Format-Wide or Format-Table. (I should add more of these $PsDefaultParameterValues statements because they’re awesome!)”

#Set Autosize switch for both Format-Table and Format-Wide cmdlet

$PSDefaultParameterValues[‘Format-[wt]*:Autosize’] = $True

Rene Mau likes to use Notepad and the console to write scripts.

“When I need information about a class or object, I’m reading the MSDN library. So the most useful profile function for me is the following. I add a ScriptMethod QuerymsdnClassInfo() to every object in the session. This method will open the MSDN website for extended information for the class.”

#Microsoft.PowerShell_profile.ps1
$ProfilePath = Split-Path -Path $PROFILE –Parent
$TypesFile = Join-Path -Path $ProfilePath -ChildPath MyTypes.ps1xml

try
{
            Update-TypeData -Path $TypesFile -EA Stop
}
catch [System.Management.Automation.ItemNotFoundException]
{
            Write-Host “Update TypeData failed. Could not find $TypesFile” -ForegroundColor DarkRed
}
catch
{
            Write-Host “Update TypeData failed. Please check syntax of $TypesFile” -ForegroundColor DarkRed
}

#MyTypes.ps1xml

<Types>
 <Type>

 <Name>System.Object</Name>

 <Members>

  <ScriptMethod>

  <Name>queryMSDNClassInfo</Name>

  <Script>

   $type = $this.GetType().FullName

   switch -Wildcard ($type)

   {

   “System.Management.ManagementObject” { $urilist = “http://msdn.microsoft.com/en-us/library/windows/desktop/aa394554`(v=vs.85`).aspx” }

   “System.__ComObject” { $urilist = “http://www.microsoft.com/com/default.mspx” }

   default { $urilist = “http://msdn.microsoft.com/$PSUICulture/library/$type.aspx” }

   }

   foreach ($uri in $urilist)

   {

   If (-not $($global:iemsdn.Type) -eq “HTML Document”)

   {

    $global:iemsdn = new-object -comobject InternetExplorer.Application -property @{navigate2 = $uri; visible = $true}

   }

   else

   {

    $global:iemsdn.navigate2($uri,0x1000)

   }

   }

  </Script>

  </ScriptMethod>

 </Members>

 </Type>

</Types>

Stefan Stranger specializes in System Center Operations Manager and Windows PowerShell.

“I love to use Windows PowerShell to automate and inspect systems I am working on. During the many Windows PowerShell workshops that I deliver, I’ve added more in my profile. That’s why I’ve added information about what is in my profile when I start my different Windows PowerShell hosts. In my console profile, I have the following functions.”

Write-Host “Loaded in profile: Measure-Script, Scripts drive” -ForegroundColor Yellow

Write-Host “Loaded in profile: PSReadLine” -ForegroundColor Yellow

Write-Host “PSReadline example: Get-Process –<Ctrl+Space> or Get-Process i <Ctrl+Space>” -ForegroundColor Yellow

# Load Module PSProfile Module

# More info http://www.powershellmagazine.com/2013/05/13/measuring-powershell-scripts/

import-module PSProfiler

 

#Go to default Script folder

Set-Location C:ScriptsPS

 

#Create FileSystem Drive for Script folder

New-PSDrive -Name Scripts -PSProvider FileSystem -Root C:ScriptsPS | Out-Null

 

# Load Module PSReadLine Module

# More info https://github.com/lzybkr/PSReadLine

import-module PSReadLine

 

“In my ISE profile, I have the following functions.”

Write-Host “Loaded in profile: Measure-Script, Scripts drive” -ForegroundColor Yellow

# Load Module PSProfile Module

# More info http://www.powershellmagazine.com/2013/05/13/measuring-powershell-scripts/

import-module PSProfiler

 

#Go to default Script folder

Set-Location C:ScriptsPS

 

#Set WindowsTitle

((Get-Host).UI.RawUI).WindowTitle = “PowerShell Rocks!”

 

#Create FileSystem Drive for Script folder

New-PSDrive -Name Scripts -PSProvider FileSystem -Root C:ScriptsPS | Out-Null

#Script Browser Begin

Function Start-ScriptBrowser

{

  Add-Type -Path ‘C:Program Files (x86)Microsoft CorporationMicrosoft Script BrowserSystem.Windows.Interactivity.dll’

  Add-Type -Path ‘C:Program Files (x86)Microsoft CorporationMicrosoft Script BrowserScriptBrowser.dll’

  Add-Type -Path ‘C:Program Files (x86)Microsoft CorporationMicrosoft Script BrowserBestPractices.dll’

  #Check if ScriptBrowser is already added to AddOnTools

  if (!($psISE.CurrentPowerShellTab.VerticalAddOnTools.Name -eq “Script Browser”))

    {

      $scriptBrowser = $psISE.CurrentPowerShellTab.VerticalAddOnTools.Add(‘Script Browser’, [ScriptExplorer.Views.MainView], $true)

    }

  #Check if ScriptAnalyzer is already added to AddOnTools

  if (!($psISE.CurrentPowerShellTab.VerticalAddOnTools.Name -eq “Script Analyzer”))

  {

    $scriptAnalyzer = $psISE.CurrentPowerShellTab.VerticalAddOnTools.Add(‘Script Analyzer’, [BestPractices.Views.BestPracticesView], $true)

  }

  if (!($psISE.CurrentPowerShellTab.VerticalAddOnTools.Name -eq “Script Browser”))

  {

    $psISE.CurrentPowerShellTab.VisibleVerticalAddOnTools.SelectedAddOnTool = $scriptBrowser

  }

 

}

#Script Browser End

“That’s it. I write a blog on TechNet: Stefan Stranger’s Weblog – Manage your IT Infrastructure. You can also find me on Twitter.”

Jason Walker offers the following ideas:

“I like to use my Windows PowerShell profile to start off my day with a laugh. I do this with the Sapi.SPVoice COM object. When Windows PowerShell is launched, my computer is inspired by LMFAO’s “Party Rock Anthem,” and it informs me that it’s time to shuffle.

“In the following script, first I create the Sapi.SPVoice COM object. Then I switch the voice from David to Zira, and I use Get-Date to get the day of the week to use in the greeting. Lastly, I switch the voice back to David and state the second half of the greeting.”

#Create Sapi.Spvoice COM object

$Sapi = New-Object -ComObject sapi.spvoice

#Switch Voice from David to Zira

$Sapi.Voice = $Sapi.GetVoices().Item(2)

#State what “day of the week” shuffle it is

$Sapi.Speak(“Time for the $((Get-Date).DayofWeek) shuffle”)

#Switch the voice back to David

$Sapi.Voice = $Sapi.GetVoices().Item(0)

#Slow the rate of speach down

$Sapi.Rate = -3

#State last half of greeting

$Sapi.Speak(“Everyday I’m shuff-a-linn”)

“Yes I know…it’s kind of cheesy, but it makes me laugh.”

Martin Schvartzman provides the following script to configure a transcript and to import a command’s history from previous sessions:

#region Transcript and History management

function Bye() {

    Stop-Transcript

    Write-Host “Transcript stopped. Exporting History… ” -ForegroundColor Yellow -NoNewline

    Get-History -Count $global:MaximumHistoryCount | Export-Clixml -Path $global:HistoryXmlFilePath

    Write-Host “Finished!” -ForegroundColor Green

    Start-Sleep -Milliseconds 500

    exit

}

 

function Hi() {

    Start-Transcript -Path $global:Transcript -ErrorAction SilentlyContinue

    if (Test-Path $global:HistoryXmlFilePath) {

       Import-Clixml $global:HistoryXmlFilePath | Add-History }

}

 

$global:Transcript = ‘C:TempTranscript_{0:yyyyMMddHHmmss}.log’ -f (Get-Date)

$global:MaximumHistoryCount = 1500

$global:HistoryXmlFilePath = Join-Path -Path (Split-Path -Path $PROFILE -Parent) -ChildPath PSHistory.xml

$ExitAction = { Bye }

[void](Register-EngineEvent –SourceIdentifier PowerShell.Exiting –Action $ExitAction)

Hi

#endregion

Matt Reynolds doesn’t want his scripts to have accidental dependencies.

“I try to avoid loading things in the profile because I use too many different machines. However, I have a module full of utility functions, which I load and bundle as needed. The following function is a recent addition. It provides memory efficient sums, counts, averages, and so on. It is aggregated by property values. Think of it as a pivot table on a pipeline.”

<#

.Synopsis

  Measures averages, sums, counts, etc over a series of object with grouping by property values, like a pivot table

.DESCRIPTION

  Measures averages, sums, counts, etc over a series of object with grouping by property values, like a pivot table

  Avoids holding all the objects in memory for scalability

.EXAMPLE

  ## Get counts, sums, avgs, etc. for file length by extension

  Get-ChildItem c: -Recurse | Measure-MLib__Aggregate -GroupProperty Extension -MeasureProperty Length -OutPipeHt

.EXAMPLE

  ## Get counts, sums, avgs, etc. for multiple numerical columns in a log file while grouping by multiple text columns

  Get-Content -Path somelogfile.txt | ConvertFrom-CSV | Measure-MLib__Aggregate -GroupProperty SourceIp,RequestType -MeasureProperty Size,ResponseTime -OutPipeHt

.INPUTS

  Any object(S)

.OUTPUTS

  Varies depending on -Passthru and other parameters

#>

function Measure-MLib__Aggregate{

  [CmdletBinding()]

  param(

                ## Input any stream of objects (e.g., psobjects, hashtables, etc.) with

                ## properties that you want to count/sum/average

    [Parameter(ValueFromPipeline=$true)]

    [object[]]$InputObject,

    ## Causes the input object(s) to be output instead of the measurement object

                ## Use together with $SideOutputHtVariableName or $SideOutputArrayVariableName

                ## to have the measurements sent to a variable while the input objects continue down output pipeline

                [switch]$Passthru,

                ## See Passthru

    [string]$SideOutputHtVariableName = $null,

                ## See Passthru

                [string]$SideOutputArrayVariableName = $null,

                ## One or more property names by which to aggregate

    [string[]]$GroupProperty,

                ## One or more property names by which to measure after aggregation

    [string[]]$MeasureProperty,

                ## Causes the measurement results to be output as a flattened table / stream

                [switch]$OutPipeFlat,

                ## Causes the measurement results to be output as a hierachial hashtable

                [switch]$OutPipeHt

  )

  begin{

    $groups = @{}

 

    function New-MLib__MeasurementsHashTable{

      param( [string[]]$propertyNames )

      $outer = @{}

      foreach($propertyName in $propertyNames){

        $outer[$propertyName] = @{

          PropertyName = $propertyName

          Count = 0

          Sum = 0

          Avg = 0

          Max = 0

          Min = 0

        }

      }

      $outer

    }

 

                function ConvertFrom-MLib__AggregateMeasure{

                        param(

                                [hashtable]$AggregateMeasure

                        )

 

                        foreach( $aggregateKey in $AggregateMeasure.Keys ){

                                foreach( $propertyMeasure in $AggregateMeasure[$aggregateKey].Values ){

   &n