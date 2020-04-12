Claus Nielsen stated that in his day-to-day work, he does not use a Windows PowerShell profile. There are several reasons for this, for example, he forgets to move it when he reinstalls his workstation. When he does demo’s, he has a script that puts line numbers in the Windows PowerShell console, which makes accessing history easier.

Boe Prox shares a couple of pretty cool ideas. He creates a modules drive. He also starts the transcript, and stores it in a specific location, but rather than letting the transcripts collect dust, he deletes them if they are more than 14 days old. He also creates a shortcut to the Windows PowerShell type accelerator, and he has a cool function that gets the constructor for classes. Like many people, Boe creates an alias for his custom functions.

## Module PSDrive

# Create Modules directory if it doesn't exist

New-Item -Path ($env:PSModulePath -split ';')[0] -ItemType Directory -ErrorAction SilentlyContinue

New-PSDrive -Name PSModule -PSProvider FileSystem -Root ($env:PSModulePath -split ';')[0]

 

## Transcript

Write-Verbose ("[{0}] Initialize Transcript" -f (Get-Date).ToString()) -Verbose

If ($host.Name -eq "ConsoleHost") {

    $transcripts = (Join-Path $Env:USERPROFILE "Documents\WindowsPowerShell\Transcripts")

    If (-Not (Test-Path $transcripts)) {

            New-Item -path $transcripts -Type Directory | out-null

            }

    $global:TRANSCRIPT = ("{0}\PSLOG_{1:dd-MM-yyyy}.txt" -f $transcripts,(Get-Date))

    Start-Transcript -Path $transcript -Append

    Get-ChildItem $transcripts | Where {

        $_.LastWriteTime -lt (Get-Date).AddDays(-14)

    } | Remove-Item -Force -ea 0

}

 

## Type accelerator shortcut

$accelerator = [PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')

$null = $accelerator::Add('accelerator',$accelerator)

 

## Get-Constructor function and alias

Function Get-Constructor {

    <#

        .SYNOPSIS

            Displays the available constructor parameters for a given type

 

        .DESCRIPTION

            Displays the available constructor parameters for a given type

 

        .PARAMETER Type

            The type name to list out available contructors and parameters

 

        .PARAMETER AsObject

            Output the results as an object instead of a formatted table

 

        .EXAMPLE

            Get-Constructor -Type "adsi"

 

            DirectoryEntry Constructors

            —————————

 

            System.String path

            System.String path, System.String username, System.String password

            System.String path, System.String username, System.String password, System.DirectoryServices.AuthenticationTypes aut…

            System.Object adsObject

 

            Description

            ———–

            Displays the output of the adsi contructors as a formatted table

 

        .EXAMPLE

            "adsisearcher" | Get-Constructor

 

            DirectorySearcher Constructors

            ——————————

 

            System.DirectoryServices.DirectoryEntry searchRoot

            System.DirectoryServices.DirectoryEntry searchRoot, System.String filter

            System.DirectoryServices.DirectoryEntry searchRoot, System.String filter, System.String[] propertiesToLoad

            System.String filter

            System.String filter, System.String[] propertiesToLoad

            System.String filter, System.String[] propertiesToLoad, System.DirectoryServices.SearchScope scope

            System.DirectoryServices.DirectoryEntry searchRoot, System.String filter, System.String[] propertiesToLoad, System.D…

 

            Description

            ———–

            Takes input from pipeline and displays the output of the adsi contructors as a formatted table

 

        .EXAMPLE

            "adsisearcher" | Get-Constructor -AsObject

 

            Type                                                        Parameters

            —-                                                        ———-

            System.DirectoryServices.DirectorySearcher                  {}

            System.DirectoryServices.DirectorySearcher                  {searchRoot}

            System.DirectoryServices.DirectorySearcher                  {searchRoot, filter}

            System.DirectoryServices.DirectorySearcher                  {searchRoot, filter, propertiesToLoad}

            System.DirectoryServices.DirectorySearcher                  {filter}

            System.DirectoryServices.DirectorySearcher                  {filter, propertiesToLoad}

            System.DirectoryServices.DirectorySearcher                  {filter, propertiesToLoad, scope}

            System.DirectoryServices.DirectorySearcher                  {searchRoot, filter, propertiesToLoad, scope}

 

            Description

            ———–

            Takes input from pipeline and displays the output of the adsi contructors as an object

 

        .INPUTS

            System.Type

       

        .OUTPUTS

            System.Constructor

            System.String

 

        .NOTES

            Author: Boe Prox

            Date Created: 28 Jan 2013

            Version 1.0

    #>

    [cmdletbinding()]

    Param (

        [parameter(ValueFromPipeline=$True)]

        [Type]$Type,

        [parameter()]

        [switch]$AsObject

    )

    Process {

        If ($PSBoundParameters['AsObject']) {

            $type.GetConstructors() | ForEach {

                $object = New-Object PSobject -Property @{

                    Type = $_.DeclaringType

                    Parameters = $_.GetParameters()

                }

                $object.pstypenames.insert(0,'System.Constructor')

                Write-Output $Object

            }

 

 

        } Else {

            $Type.GetConstructors() | Select @{

                                Label="$($type.Name) Constructors"

                                Expression={($_.GetParameters() | ForEach {$_.ToString()}) -Join ", "}

                    }

        }

    }

}

New-Alias gctor Get-Constructor

Dave Wyatt shares two functions. The first is New-ISETab, and the second is Get-ProxyCode. The first function opens code on a new tab in the Windows PowerShell ISE, and the second function is a helper function that makes it easier to write a proxy function. Both are cool.

gpc Send-MailMessage | nt

(aliases for: Get-ProxyCode –Name Send-MailMessage | New-ISETab )

function New-ISETab {

    [CmdletBinding()]

    param(

        [Parameter(Mandatory=$false, Position=1, ValueFromPipeline = $true)]

        [System.String[]]

        $Text,

        [Parameter(Mandatory=$false)]

        [System.Object]

        $Separator

    )

   

    begin {

        if (!$psISE) {

            throw 'This command can only be run from within the PowerShell ISE.'

        }

 

        if ((!$PSBoundParameters['Separator']) -and (Test-Path 'variable:\OFS')) {

            $Separator = $OFS

        }

 

        if (!$Separator) { $Separator = "`r`n" }

 

        $tab = $psISE.CurrentPowerShellTab.Files.Add()

       

        $sb = New-Object System.Text.StringBuilder

    }

   

    process {

        foreach ($str in @($Text)) {

            if ($sb.Length -gt 0) {

                $sb.Append(("{0}{1}" -f $Separator, $str)) | Out-Null

            } else {

                $sb.Append($str) | Out-Null

            }

        }

    }

 

    end {

        $tab.Editor.Text = $sb.ToString()

        $tab.Editor.SetCaretPosition(1,1)

    }

}

 

Set-Alias -Name nt -Value New-ISETab

function Get-ProxyCode {

    [CmdletBinding()]

    [OutputType([String])]

    param (

        [Parameter(Mandatory=$true, Position=0)]

        [System.String]

        $Name,

        [Parameter(Mandatory=$false,Position=1)]

        [System.Management.Automation.CommandTypes]

        $CommandType

    )

    process {

        $command = $null

        if ($PSBoundParameters['CommandType']) {

            $command = $ExecutionContext.InvokeCommand.GetCommand($Name, $CommandType)

        } else {

            $command = (Get-Command -Name $Name)

        }

 

        # Add a function header and indentation to the output of ProxyCommand::Create

       

        $MetaData = New-Object System.Management.Automation.CommandMetaData ($command)

        $code = [System.Management.Automation.ProxyCommand]::Create($MetaData)

 

        $sb = New-Object -TypeName System.Text.StringBuilder

 

        $sb.AppendLine("function $($command.Name)") | Out-Null

        $sb.AppendLine('{') | Out-Null

 

        foreach ($line in $code -split "\r?\n") {

            $sb.AppendLine('    {0}' -f $line) | Out-Null

        }

 

        $sb.AppendLine('}') | Out-Null

 

        $sb.ToString()

    }

}

Set-Alias -Name gpc -Value Get-ProxyCode 

David Moravec states that in his Windows PowerShell profile, he likes to use various Windows PowerShell drives to access important folders. One custom Windows PowerShell drive points to his user profile and to a folder called Projects: 

New-PSDrive -Name Projects -PSProvider FileSystem -Root "$env:USERPROFILE\Projects" | Out-Null

He also has code that will load all scripts from a specific folder. This is a pretty cool idea, and works well if you organize your scripts according to a specific project. You can then use Get-ChildItem to open the scripts:

# Load all scripts

Get-ChildItem (Join-Path ('Dropbox:\PowerShell\Profile') \Scripts\) |? `

    { $_.Name -notlike '__*' -and $_.Name -like '*.ps1'} |% `

    { . $_.FullName }

He also has functions that simplify common tasks, such as sending an email to his wife:

function MailToAndrea

{

    param($s, $b)

 

    $prop = @{

        From = 'David.Moravec@mainstream.cz'

        SmtpServer = $SMTPServer

        To = 'andrea.moravcova@<domain>.com' 

        Subject = $s

        Body = $b

    }

 

    Send-MailMessage @prop

}

Set-Alias -Name m2a -Value MailToAndrea

Jan Egil Ring shared the following tip:

"Here is a generalized script I use in my profile to load different customizations, based on which Active Directory domain I log in to. My ~\Documents\WindowsPowerShell folder is synchronized across my profile in each domain by using OneDrive. This way, I`m able to load different variables (cluster names and so on), based on where I`m working."

# Environment specific set up

 

$PSProfileRoot = Split-Path $MyInvocation.MyCommand.Path -Parent

 

switch ($env:USERDOMAIN)

{

 

'CORP' {

 

    try {

        . (Join-Path -Path $PSProfileRoot -ChildPath Environments\Corp\setup.ps1 -Resolve -ErrorAction stop)

        }

    catch {

        Write-Warning "Corp customization script not available"

        }

    }

 

'AZURE' {

 

    try {

        . (Join-Path -Path $PSProfileRoot -ChildPath Environments\Azure\setup.ps1 -Resolve -ErrorAction stop)

        }

    catch {

        Write-Warning "Azure customization script not available"

        }

    }

 

}

Jeffery Hicks shared the following:

"I take advantage of multiple profiles. Settings that should apply to the ISE and the console go in $profile.CurrentUserAllHosts. I then have host-specific profiles for settings that only make sense in the console or the ISE. Following are a few items that might be of interest."

1. Set some default locations for a few PSDrives.

(get-psdrive c).CurrentLocation="\scripts"
(get-psdrive d).CurrentLocation="\temp"
(get-psdrive hklm).CurrentLocation="\Software\Microsoft\Windows\CurrentVersion"

2. Define a function I can use to kick off a new v2 session.

Function New-V2Session {
#This must be run in an elevated session

Param([switch]$noprofile)

#Modify PowerShell.exe.Config if found
$exeConfig= Join-Path -path $PSHome -ChildPath "PowerShell.exe.config"
if (Test-Path $ExeConfig) {
    $config = Get-Content -Path $exeConfig
    #set policy to false to allow starting a v2 session
    $config.configuration.startup.useLegacyV2RuntimeActivationPolicy="False"
    $config.Save($exeConfig)
}

#start a new PowerShell v2 session
  if ($NoProfile) {
   $new = Start-Process -file PowerShell.exe -arg ' -version 2.0 -nologo -noprofile' -PassThru
  }
  else {
   $new = Start-Process -file PowerShell.exe -arg ' -version 2.0 -nologo' -PassThru
  }

#give the new processes a chance to start
Do {
 Start-Sleep -Milliseconds 100
} Until ($new)

#wait a few more seconds 
Start-Sleep -Seconds 2

#change the config file back
If ($config) {
 #change the config back to avoid breaking PowerShell 3
 $config.configuration.startup.useLegacyV2RuntimeActivationPolicy="True"
 $config.Save($exeConfig)
}
} #end function

3. Call a function to display a quote of the day.

#requires -version 3.0

Function Get-QOTD {
<#
.Synopsis
Download quote of the day.
.Description
Using Invoke-RestMethod download the quote of the day from the BrainyQuote RSS
feed. The URL parameter has the necessary default value.
.Example
PS C:\> get-qotd
"We choose our joys and sorrows long before we experience them." – Khalil Gibran
.Link
Invoke-RestMethod
#>
    [cmdletBinding()]

    Param(
    [Parameter(Position=0)]
    [ValidateNotNullorEmpty()]
    [string]$Url="http://feeds.feedburner.com/brainyquote/QUOTEBR"
    )

    Write-Verbose "$(Get-Date) Starting Get-QOTD"  
    Write-Verbose "$(Get-Date) Connecting to $url"

    Try
    {
        #retrieve the url using Invoke-RestMethod
        Write-Verbose "$(Get-Date) Running Invoke-Restmethod"
        
        #if there is an exception, store it in my own variable.
        $data = Invoke-RestMethod -Uri $url -ErrorAction Stop -ErrorVariable myErr

        #The first quote will be the most recent
        Write-Verbose "$(Get-Date) retrieved data"
        $quote = $data[0]
    }
    Catch
    {
        $msg = "There was an error connecting to $url. "
        $msg += "$($myErr.Message)."

        Write-Warning $msg
    }

    #only process if we got a valid quote response
    if ($quote.description)
    {
        Write-Verbose "$(Get-Date) Processing $($quote.OrigLink)"
        #write a quote string to the pipeline
        "{0} – {1}" -f $quote.Description,$quote.Title
    }
    else
    {
        Write-Warning "Failed to get expected QOTD data from $url."
    }

    Write-Verbose "$(Get-Date) Ending Get-QOTD"

} #end Get-QOTD

#OPTIONAL: create an alias
Set-Alias -name "qotd" -Value Get-QOTD

Tome Tanasovski contributed the following:

"The most essential part of my profile includes two very important lines of code. The intention of these lines is to strike fear in the hearts of men (and women) who are brave enough to watch me start Windows PowerShell.  It also makes me smile every time I see it."

(("1*0x26*1×3*2×4*3×1*4×1*2×2*1×1*2×1*4×4*3×3*2×21*1×1*0x20*1×1*2×2*4×3*5×5*6×2*7×6*1×2*8×5*6×3*5×2*4×1*2×15*1×1*0x17*1×1*2×1*4×1*5×10*6×2*7×1*1×1*9×4*1×1*10×1*1×2*8×10*6×1*5×1*4×1*2×13*1×1*0x16*1×1*4×12*6×2*7×2*1×1*11×1*8×2*5×1*7×1*11×2*1×2*8×12*6×1*4×11*1×1*0x14*1×1*2×1*7×12*6×2*7×3*1×1*9×1*12×2*13×1*14×1*10×3*1×2*8×12*6×1*8×1*2×9*1×1*0x14*1×1*7×13*6×2*9×4*1×2*8×2*7×5*1×2*10×13*6×1*8×9*1×1*0x12*1×1*4×15*6×2*8×4*1×1*9×2*15×1*10×4*1×2*7×15*6×1*4×7*1×1*0x11*1×1*4×17*6×2*8×2*1×1*7×1*1×2*16×1*1×1*8×2*1×2*7×17*6×1*4×7*1×1*0x10*1×1*4×19*6×2*8×1*7×6*1×1*8×2*7×19*6×1*4×5*1×1*0x9*1×1*2×1*6×1*7×1*11×10*6×1*7×1*8×6*6×1*9×3*1×1*7×1*8×3*1×1*10×6*6×1*7×1*8×10*6×1*11×1*8×1*6×1*2×5*1×1*0x9*1×1*11×1*7×1*1×1*11×1*6×1*7×1*8×1*6×1*7×1*8×1*6×1*7×1*8×1*7×2*1×1*8×1*6×1*7×1*8×2*6×1*8×2*1×1*11×2*1×1*11×2*1×1*7×2*6×1*7×1*8×1*6×1*7×2*1×1*8×1*7×1*8×1*6×1*7×1*8×1*6×1*7×1*8×1*6×1*11×1*1×1*8×1*11×5*1×1*0x9*1×1*17×2*1×1*11×1*7×2*1×1*16×2*1×1*16×2*1×1*17×3*1×1*16×2*1×1*8×1*6×1*8×1*11×1*1×1*11×2*1×1*11×1*1×1*11×1*7×1*6×1*7×2*1×1*16×3*1×1*17×2*1×1*16×2*1×1*16×2*1×1*8×1*11×2*1×1*18×5*1×1*0x13*1×1*17×3*1×1*17×2*1×1*17×6*1×1*17×2*1×1*7×1*1×1*11×1*1×1*11×2*1×1*11×1*1×1*11×1*1×1*8×3*1×1*17×6*1×1*17×2*1×1*17×3*1×1*17×7*1×1*0x29*1×1*9×2*1×1*11×1*1×1*11×2*1×1*11×1*1×1*11×2*1×1*10×25*1×1*0x4*1×1*19×1*20×1*15×1*17×1*21×1*1×1*22×1*20×1*23×1*1×1*24×1*25×1*21×1*22×1*23×1*26×1*27×1*28×1*27×1*28×1*27×3*1×2*2×1*8×1*1×1*11×1*1×1*11×2*1×1*11×1*1×1*11×1*1×1*7×2*2×1*1×1*29×1*15×1*30×1*31×1*32×2*33×1*28×1*1×1*22×1*15×1*23×1*34×1*32×2*35×1*36×1*37×1*38×1*25×1*39×1*40×1*41×1*42×1*15×1*38×1*0x27*1×1*9×3*43×1*9×3*16×1*10×1*9×3*16×1*10×3*43×1*10×6*1×1*0x22*1×1*20×2*22×1*44×1*13×2*7×1*44×1*15×1*45×1*23×1*26×1*22×1*15×1*23×1*41×1*45×1*15×1*26×1*46×1*44×1*26×1*23×2*21×1*41×1*42×1*15×1*38×1*0" -split "x") -split "x"|%{ if ($_ -match "(\d+)\*(\d+)") { "$([char][int]("10T32T95T61T45T94T35T47T92T40T41T124T62T58T60T111T86T39T44T87T104T115T116T101T77T97T114T63T33T84T69T78T117T70T110T102T64T103T109T105T108T46T99T118T112T119T100" -split "T")[$matches[2]])" * $matches[1] } }) -join 
""

$host.UI.RawUI.WindowTitle = "By the powershell of greyskull"

 

"If this inspires you, you should read through this post on the Windows PowerShell Forum from 2010: Post your sig thread.

"Besides a multitude of aliases for different languages and tools like Perl, Python, golang, Pester, and Git, I keep the following function, which allows me to quickly grep through the history of commands I have recently typed."

function hgrep {

    param(

        [Parameter(Mandatory=$false, Position=0)]

        [string]$Regex,

        [Parameter(Mandatory=$false)]

        [switch]$Full

    )

    $commands = get-history |?{$_.commandline -match $regex}

    if ($full) {

        $commands |ft *

    }

    else {

        foreach ($command in ($commands |select -ExpandProperty commandline)) {

            # This ensures that only the first line is shown of a multiline command

            # You can always get the full command using get-history or you can fork and remove this from the gist

            if ($command -match '\r\n') {

                ($command -split '\r\n')[0] + " …"

            }

            else {

                $command

            }

        }

    }

} 

"Finally, my prompt is very simple. I like to add the time that the last command finished to every line. I do this with the following prompt function."

function prompt {

    (get-date).ToString("HH:mm:ss") + " " + $(if (test-path variable:/PSDebugContext) { '[DBG]: ' } else { '' }) + 'PS ' + (Get-Location).ProviderPath + $(if ($nestedpromptlevel -ge 1) { '>>' }) + '> '

}

"Additionally, I run posh-git to ensure that my prompt provides me with Git information for the directory I'm in. My entire profile lives in a GitHub Gist. You can read through it here: toenuff  / profile.ps1."

Bartek Bielawski shared the following:

"First of all, I’m huge fan of script signing. In my opinion, people should make sure that their environment is safe from a malicious profile. After all, this is simply a text file in a documents folder, and nothing (as far as I know) is protecting it. During my Windows PowerShell security talk, I use a “profile” that starts as follows."

Write-Progress -PercentComplete 0 -Activity 'Deleting users from AD..'

Start-Sleep -Seconds 1

foreach ($Percent in 1..99) {

    Write-Progress -PercentComplete $Percent -Activity 'Deleting users from AD..' -Status "Delete so far: $($Percent * 100) :D"

    Start-Sleep -Milliseconds 200

}

Write-Progress -PercentComplete 100 -Activity 'And now I will kill your PC. BSOD!'

Start-Sleep -Seconds 1

"After that, I show an actual "blue screen of death" in Windows 8, blur it out, and finalize it with some silly graphics. To prevent this from happening in real life, I have used the same setup for years, and it’s something I learned from Glenn Sizemore’s blog. (Unfortunately, I can’t provide you with URL to Glenn’s post—his blog is long gone.) The setup includes:

The execution policy is configured to AllSigned.
Any profile script I use is signed.
In the last profiles, before I load any modules, I change the execution policy for the current process to RemoteSigned.
"Now if someone tries to modify my profile, I will get information that it was modified, and it won’t run. At the same time, I can run any script I want. (But hey, I’m doing it on purpose, so if the script is bad, I’m the one to blame.) With profiles, it’s not always a voluntary run.

"Before Tobias Weltner made the ISESteroids add-in public, I had a different issue: Whenever I updated my profile, I needed something to update its signature too. That’s how I ended up with the following handy little function. It updates the digital signature of any script, but it defaults to my profile."

function Update-ScriptSignature {

param (

    [string]$FilePath = $profile,

    [Security.Cryptography.X509Certificates.X509Certificate2]$Certificate = $(

        Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert |

            Where-Object { $_.Verify() } |

            Select-Object -First 1)

)

    $Params = @{

        FilePath = $FilePath

        Certificate = $Certificate

        TimestampServer = 'http://timestamp.digicert.com'

    }

    Set-AuthenticodeSignature @Params

}

"As you can see, it will take the first code-signing certificate I have that can be verified, and sign my script with it. It uses TimestampServer, which is something people tend to ignore. Why would you use it? Well, if someone told you that after your digital signature expires, any script you’ve signed with it will no longer be valid, they lied.

"That’s exactly what a time stamp is for—it’s proof that your script was signed when the signature was valid. That prevents nasty tricks with moving clocks that could keep a yearly certificate valid forever. And that’s why a script without a time stamp “dies” when the certificate expires.

"Following is a good example. It is a script I signed two years ago, and it is still valid, even though my certificate expired. Without the time stamp, I would have to sign it again or ignore the fact that it has any signature."

<# Provider: FileSystem => Location: E:\PowerShell ID: [25]

#>⁠⁠⁠ Get-AuthenticodeSignature .\LocalAdminGUI.ps1 |

    Format-List Status, { $_.SignerCertificate.NotAfter }, TimeStamperCertificate, {Get-Date}

Status                          : Valid

$_.SignerCertificate.NotAfter  : 21-Mar-13 13:00:00

TimeStamperCertificate          : [Subject]

                                    CN=DigiCert Timestamp Responder, O=DigiCert, C=US

                                 

                                  [Issuer]

                                    CN=DigiCert Assured ID CA-1, OU=www.digicert.com, O=DigiCert Inc, C=US

                                 

                                  [Serial Number]

                                    038B96F070D9E21E55A5426792E1C83A

                                 

                                  [Not Before]

                                    04-Apr-12 02:00:00

                                 

                                  [Not After]

                                    18-Apr-13 02:00:00

                                 

                                  [Thumbprint]

                                    51AEC7BA27E71A65D36BE1125B6909EE031119AC

                                  

Get-Date                        : 09-May-14 23:46:26