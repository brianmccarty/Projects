Michael Lyons shared this:

To make my Windows PowerShell profile easier to use, I like to customize it with:

Some additional aliases to give a quick shorthand to common commands.
A prompt that has color and times every command. It shows the time if it took more than 3 seconds to run, and it beeps if it took more than 20 seconds (so if I’m reading email or browsing the web, I can tell when it’s done).
A replacement for “dir” and “rd” that call “cmd.exe” so that the syntax is the same. It’s too burnt into my brain. If I’m currently in a PS drive, it will mount it to a valid drive letter first (because cmd.exe must be called from a valid drive).
A hosts function to edit $env:windirsystem32driversetchosts.
Some Update-FormatData changes. For example, file sizes shown with gci have thousands separators, junctions will show that they are junctions, and certificates will show if they have a private key.
Here’s my dir function:

function GLOBAL:dir

{

    $cwd = & cmd.exe /c cd 2> $null

    if ($cwd -eq $pwd.Path)

    {

        & cmd.exe /c dir $args

    }

    else

    {

        $cwd = $pwd.ProviderPath

        pushd $home

        & cmd.exe /c pushd “$cwd” `& dir $args

        popd

    }

}

Tiger Wang provided the following function called DllOptimizationControl.psm1. Each function recursively turns ON and OFF the optimization for each DLL under the current path. For more information about, .NET Framework Debugging Control, see Making an Image Easier to Debug.

function Disable-DllOptimization($path=”$PWD”)

{

    Get-ChildItem $path -Recurse | Where-Object {$_.Name.Contains(“.dll”)} |
    ForEach-Object {$_.FullName.Replace(“.dll”, “.ini”)} | ForEach-Object {Remove-Item $_ -Force}

}

 

function Enable-DllOptimization($path=”$PWD”)

{

    $debugInfo =

@’

[.NET Framework Debugging Control]

AllowOptimize=0

GenerateTrackingInfo=1

‘@

 

    Get-ChildItem $path -Recurse | Where-Object {$_.Name.Contains(“.dll”)} | 
     ForEach-Object {$_.FullName.Replace(“.dll”, “.ini”)} | ForEach-Object {$debugInfo | Out-File $_}

}

Tim Dunn provided a link to a recent blog post he wrote called $PROFILE and RDP Sessions. I am not going to explain his entire post, but I wanted to point out one item. He has a real cool method of mapping his home drive when accessing resources by remoting into machines in different domains. It is pretty clever and it is worth a read.

Rahul Duggal wrote:

“I usually work with SQL Server, and I’ve found the following function to be useful in my profile.”

Write-Host “Loading SQLPS Module, Hold your horses!” -Fore Green # To tell user, why PS is not showing prompt yet

Import-Module SQLPS -DisableNameChecking

Write-Host “Welcome $env:USERNAME , Let’s Automate !!!” -Fore yellow  # Small motivation

Set-Location E:PowerShell #I change default directory to avoid accidental damage to important folders in C: drive

$host.PrivateData.ErrorForegroundColor = “gray”  # RED colour in error message stresses me out J