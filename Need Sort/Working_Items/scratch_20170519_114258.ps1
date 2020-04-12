Summary: Windows PowerShell principal SDE, Bruce Payette, shares a couple of cool profile functions.

Microsoft Scripting Guy, Ed Wilson, is here. The week of May 19, we had Profile Week. (To read about some great ideas that you can use for your Windows PowerShell profile, see these Hey, Scripting Guy! Blog posts.) I saved one individual's profile for a special post. Today we will look inside Bruce Payette’s profile. For anyone who may not know, Bruce is a principal software development engineer (SDE) on the Windows PowerShell team. Now you know why this is a special post.

Bruce supplied three way cool functions. The first function is a CD function that stores a list of directories that are typed. Then there is a DIRS function that will list the directories that have been typed. Each directory is associated with a number. Lastly, there is a MY function that creates directories relative to the users documents folder. I copied the functions below into my Windows PowerShell console profile. I typed ise $profile to open my profile in the Windows PowerShell ISE. Here is my Windows PowerShell ISE:

Image of console

A new CD function
In a default installation of Windows PowerShell, the CD alias is mapped to the Set-Location cmdlet. It changes directories. So the first thing that Bruce does is remove the CD alias, and then create a new function named CD. The cool thing about the new CD function is that it stores a list of directories that I visit. Each path is added once. With the new function, I can use CD, and move backwards in the directory bag.

With the DIRS function, I get a list of the directories stored in the directory bag. I can list them by typing dirs, or I can go to a specific folder by typing dirs 2, or whatever directory I want to navigate to. This is shown in the following image:

Image of command output

The MY function maps directories in reference to my personal profile. It allows me to go directly to my personal module folder by typing my modules, as shown here:

Image of command output

Following is the complete script for the three way cool profile functions:

# remove any existing cd alias…

rm -force alias:/cd 2> $null

$global:DIRLIST = @{}

# a cd function that maintains a list of directories visited. Each path is added only once (bag not stack)

# it also implements the UNIX-like ‘cd –‘ to jump back to the previous directory

# cd …            # go up 2 levels

# cd ….           # go up three levels

# cd –              # go back to the previous directory

function cd

{

  param ($path='~', [switch] $parent, [string[]] $replace, [switch] $my, [switch] $one)

 

  if ($index = $path -as [int])

  {

    dirs $index

    return

  }

 

  if ($replace)

  {

    $path = $path -replace $replace

  }

 

  if ($parent)

  {

    $path = Split-Path path

  }

 

  if ($my)

  {

    if ($path -eq '~') { $path = '' }

    $path = "~/documents/$path"

  }

  elseif ($one)

  {

    if ($path -eq '~') { $path = '' }

    $path = "~/skydrive/documents/$path"

  }

 

  # .'ing shortcuts

  switch ($path)

  {

    '…' { $path = '..\..' }

    '….' { $path = '..\..\..' }

    '-' {

      if (test-path variable:global:oldpath)

      {

        # pop back to your old path

        Write-Host "cd'ing back to $global:OLDPATH"

       

        $temp = Get-Location

        Set-Location $global:OLDPATH

        $global:OLDPATH=$temp

      }

      else

      {

        Write-Warning 'OLDPATH not set'

      }

    }

    default {

      $temp = Get-Location

      Set-Location $path

      if ($?) {

        $global:OLDPATH = $temp

        $DIRLIST[(Get-Location).path] = $true

      }

      else

      {

        Write-Warning 'cd failed!'

      }

    }

  }

}

 

#

# lists the directories accumulated by the cd function

# dirs              # list the accumulated directories

# dirs <number>     # cd to the directory entry corresponding to <number>

function dirs

{

  param ($id = -1)

  $dl = $dirlist.keys | sort

  if ($dl)

  {

    if ($id -ge 0)

    {

      cd $dl[$id]

    }

    else

    {

      $count=0;

      foreach ($d in $dl)

      {

        '{0,3} {1}' -f $count++, $d

      }

    }

  }

}

 

# A function that cd's relative to ~/documents, with special handling for 'my modules'

# Works with the cd function

# my           # go to ~/documents

# my modules   # cd to ~/documents/windowspowershell/modules

# my foobar    # cd to ~/documents/foobar

function my ($path='', [switch] $resolve=$false)

{

  switch ($path)

  {

    modules {

      $resolvedPath = (rvpa '~/documents/windowspowershell/modules').Path

      if ($resolve) { return $resolvePath }

      cd $resolvedPath

      return

    }

  }

  $resolvedPath = $null

  $resolvedPath =  (rvpa "~/documents/$path").Path

  if (! $resolvedPath ) { return }

  if ($resolve)

  {

    return $resolvedPath

  }

  else

  {

    if ((get-item $resolvedPath).PSIsContainer)

    {

      cd "~/documents/$path"

    }

    else

    {

      return $resolvedPath

    }

  }

}