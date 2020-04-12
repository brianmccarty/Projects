Alex Lee shared three functions. The functions are called Parse-Script, Find-String, and Count-Lines. Here is what he has to say about these functions:

"I use these three functions when I am working on projects that involve packaging scripts for some kind of delivery and/or sharing scripts with and from others—mostly only when I have a folder full of files."

Parse-Script. I borrowed this function from Windows PowerShell MVP, Keith Hill. 
Find-String. I don’t actually remember why I wrote this function. I think I wanted to use the command prompt to find files that need to change (for example, changing variable names or paths). And I think I had XML files that FINDSTR.EXE didn’t like.
Count-Lines. This is simply a way to quantify the size of a package. It ignores empty lines and comments.
Dan Bjorge shared two functions. The first one is a Format-History function that accepts a history entry as input and will display the amount of time a job in the history ran. The second function is a customized Windows PowerShell prompt.

Format-History function

function Format-History($HistoryEntry) {

    if ($HistoryEntry -ne $null) {

        $Duration = $HistoryEntry.EndExecutionTime – $HistoryEntry.StartExecutionTime

        if ($Duration.Days -ge 1) {

            $DurationString = [String]::Format("{0:0}d{1:00}h{2:00}m{3:00}s", $Duration.Days,$Duration.Hours,$Duration.Minutes,$Duration.Seconds)

        } elseif($Duration.Hours -ge 1) {

            $DurationString = [String]::Format("{0:0}h{1:00}m{2:00}s", $Duration.Hours,$Duration.Minutes,$Duration.Seconds)

        } elseif($Duration.Minutes -ge 1) {

            $DurationString = [String]::Format("{0:0}m{1:00}.{2:000}s", $Duration.Minutes,$Duration.Seconds,$Duration.Milliseconds)

        } else {

            $DurationString = [String]::Format("{0:0}.{1:000}s", $Duration.Seconds,$Duration.Milliseconds)

        }

 

        return "[$DurationString] $($HistoryEntry.CommandLine)"

    } else {

        return ""

    }

}

Customized Windows PowerShell prompt

function global:Prompt {

    $Location = (Get-Location).Path

    $LastCommand = Get-History -Count 1

    $LastCommandStr = Format-History $LastCommand

 

    $WindowTitle = "$Location | $LastCommandStr"

    $TabTitle = $Location

    if (Test-Elevated) {

        Write-Host "ADMIN " -NoNewline -ForegroundColor Red

        $WindowTitle = "[ADMIN] $WindowTitle"

    }

   

    Write-Host "$Location" -NoNewline

 

    if ($LastCommand -ne $null) {

        Write-Host " $($LastCommand.Id+1)" -NoNewline -ForegroundColor Green

    } else {

        Write-Host " 1" -NoNewline -ForegroundColor Green

    }

 

    if ($PsIse -ne $null) {

        $PsIse.CurrentPowerShellTab.DisplayName = $TabTitle

    } else {

        $Host.UI.RawUI.WindowTitle = $WindowTitle

    }

 

    return '> '

}

One cool thing that the custom prompt function does is display the admin status in red. This is shown in the following image:

Image of command output

Dan Thompson shared several functions that look pretty cool. One thing he does is turn on StrictMode. It is almost the first line in his Windows PowerShell profile. He then creates a Resolve-Error function that provides useful error messages when there is a problem. He has a pushd function that looks rather intriguing. He also has a Find-InSource function, and a Set-WindowTitle function.

I like that Dan creates useful aliases for his functions. This makes working in the Windows PowerShell shell much easier. Here are Dan's functions:

Set-StrictMode and Resolve-Error functions

Set-StrictMode -Version Latest

function Resolve-Error

{

    [CmdletBinding()]

    param( [Parameter( Mandatory = $false, Position = 0, ValueFromPipeline = $true )]

           [System.Management.Automation.ErrorRecord] $ErrorRecord )

 

    process

    {

        try

        {

            if( !$ErrorRecord )

            {

                if( 0 -eq $global:Error.Count )

                {

                    return

                }

                $ErrorRecord = $global:Error[ 0 ]

            }

 

            $global:e = $ErrorRecord

            $ErrorRecord | Format-List * -Force

            $ErrorRecord.InvocationInfo | Format-List *

            $Exception = $ErrorRecord.Exception

            for( $i = 0; $Exception; $i++, ($Exception = $Exception.InnerException) )

            {   "$i" * 80

                $Exception | Format-List * -Force

            }

        }

        finally { }

    }

}

Set-Alias rver Resolve-Error

Pushd function

function .. { pushd .. }

function … { pushd ..\.. }

function …. { pushd ..\..\.. }

function ….. { pushd ..\..\..\.. }

function …… { pushd ..\..\..\..\.. }

function ……. { pushd ..\..\..\..\..\.. }

function …….. { pushd ..\..\..\..\..\..\.. }

Set-Alias go Push-Location

Set-Alias back Pop-Location

Set-Alias l Get-ChildItem

function q { exit }

Find-InSource function

function Find-InSource

{

    findstr /spinc:"$args" *.c *.cs *.cxx *.cpp *.h *.hxx *.hpp *.idl *.wxs *.wix *.wxi *.ps1 *.psm1 *.psd1

}

Set-Alias fs Find-InSource

Set-WindowTitle function

function Set-WindowTitle()

{

    $host.ui.RawUI.WindowTitle = [String]::Join( ' ', $args )

}

Set-Alias 'title' 'Set-WindowTitle' -Scope Global

Dave Bishop shared the following:

"I customize my prompt in (what I think) is a clever and useful way. I also load a few useful modules and tools. The big thing for me is that I created a folder on my OneDrive, and I store everything there:  C:\users\davbish\OneDrive\WindowsPowerShell. I then hard link to my profile folder with junction.exe (SysInternals tool) as follows."

Junction c:\users\davbish\documents\windowspowershell c:\users\davbish\onedrive\windowspowershell

"I do this on all of my computers so my profile scripts (and more importantly, any edits) and certain modules follow me everywhere!"

Dave also customizes his prompt function, as shown here:

function Prompt

{

            $id=1

            $historyItem=get-history -count 1

            if($historyitem)

            {

                        $id=$historyItem.id+1

            }

            write-host -foregroundcolor darkgray "`n[$(get-location)]"

            write-host -foregroundcolor yellow -nonewline "PS:$id > "

            "`b"

}

Dave also creates an alias for Internet Explorer as follows:

set-alias iexplore 'c:\program files\internet explorer\iexplore.exe'

Heath Stewart shared the following:

"I added another cmdlet that I use often (although, I just finally added it to my $profile—not sure why it took me so long to do it), and you might find it useful. The idea is that sometimes you get repetitive row data like the one that follows."

Key, Property, Value

—, ——–, —–

Foo, Name, Foo

Foo, Language, 1033

Foo, Id, {GUID1}

Bar, Name, Bar

Bar, Language, 1031

Bar, Id, {GUID2}

Bar, Other, Other

"This happens a lot when processing metadata records that are user-definable. To create objects with the metadata properties as actual properties of a PSObject, you can use Join-Object as follows (Property and Value are defaults for the second and third parameters)." This is shown here:

Import-Csv foo.csv | Join-Object Key

You can download the function from GitHub: Join-Object cmdlet.

Jason Chenault provided the following:

"I found this function useful when I was supporting Exchange Server 2010. I used it whenever I needed a quick report about disconnected mailboxes or simply to clean the databases."

function Get-DisconnectedMailbox {

              

               param(

              

               [String]$Name = '*',

               [String]$Server = '*',

               [Switch]$Clean,

               [Switch]$Archive

              

               )

              

               if ($Clean) {

                              Get-MailboxDatabase | Clean-MailboxDatabase

               }

 

               $databases = Get-MailboxDatabase | ?{$_.Name -like $Server}

               $databases | %{

                              $db = Get-Mailboxstatistics -database $_.Name |

                                             ?{$_.DisconnectDate -and $_.IsArchiveMailbox -eq $Archive}

 

                              $db | ?{$_.displayname -like $Name} |

                                             Select-Object DisplayName,

                                             MailboxGuid,

                                             Database,

                                             DisconnectReason,

                                             ItemCount,

                                             disconnectDate | Out-file -append DiscMBReport.txt

                              }

}