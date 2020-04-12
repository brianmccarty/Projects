Microsoft Scripting Guy, Ed Wilson, is here. I was at the Windows PowerShell Summit a couple weeks ago. When Jason Shirk, a manager on the Windows PowerShell team, was doing a demo, I was able to glance into his Windows PowerShell profile. I was amazed by the number of cool things that were there. I thought, “Hmmmmm…”

I have had a Windows PowerShell profile since the early beta days—back when it was called Monad. I hardly consider myself to be a noob, but I am also the first to admit that I do not know everything there is to know about Windows PowerShell. In fact, I learn new stuff every single day. One of the best ways to learn, is to talk to other Windows PowerShell enthusiasts and gurus. That is one of the reason the Scripting Wife and I are such big supporters of Windows PowerShell User Groups. I firmly believe that you get a bunch of Windows PowerShell people together, and great things will happen.

So, that is the source of this week’s blog posts. I decided it would be fun to have people submit some of their favorite functions, tips, and tricks from their Windows PowerShell profile. I am also asking you to post your profile on the Scripting Guys Script Repository, or to paste your favorite function, tip, or trick into the comments section of this week’s series of posts. It will be good stuff.

Note  I have nearly twenty Hey, Scripting Guy! Blog posts where I talk about Windows PowerShell profiles. I recommend you review them prior to getting too bogged down with this week’s series.

Over the years, I have had wild and wooly Windows PowerShell profiles, and simple and serene Windows PowerShell profiles. I generally add the following components into my Windows PowerShell profile. I like to create a section for each:

Aliases
PS Drives
Functions
Variables
Initialization commands
When I am in the midst of making a lot of changes to my Windows PowerShell profile, I like to back it up each time I open Windows PowerShell. It is pretty easy to do, all I need to do is to call the following command and specify a name and a destination:

Copy-Item –path $profile

One of the things that people sometimes talk about is the need to check their profile to ensure it has not inadvertently changed —either by accident or by intention. For example, I recently downloaded a module—a reputable module from a reputable author. Come to find out, he modified my Windows PowerShell profile to call his module with specific parameters. It would have been nice if he had told me he was going to do this. Not that it caused any problems. It is just that I would have liked to have been prompted to do this myself, or given the option to allow him to do it. Know what I mean?

Some people talk about signing the Windows PowerShell profile, but that means that every time it is modified, it needs to be resigned. An easier way to detect changes is to save a file hash of the profile, and then compare the file hash on startup.

Get-ProfileHash function
So I decided to create a Get-ProfileHash function. I added this to my ISE profile and to my Windows PowerShell console profile. I added logic to the function so that it will detect which profile is in use and check that one. You can find the complete function on the Script Center Repository: Get-ProfileHash function.

I am using the Get-FileHash function from Windows PowerShell 4.0 in Windows 8.1, but there are other ways to get a file hash. They are just not quite as easy. Because of this, I add a check for Windows PowerShell 4.0 as shown here:

#requires -version 4.0

Function Get-ProfileHash

{

Now I need to get the name of the current Windows PowerShell profile. To do this, I use the Split-Path cmdlet and choose the –Leaf parameter. But this returns a string, and it includes the .PS1 file extension. So I cast the string into a [system.io.fileinfo] object type, and I then choose only the basename property. I could have parsed the string, but casting to an object and selecting a specific property works better. Here is that line of script:

$profileName = ([system.io.fileinfo](Split-Path $profile -Leaf)).basename

Now I want to get the folder that contains the $profile. That is easy, I choose the –Parent parameter from the Split-Path:

$profileFolder = Split-Path $profile -Parent

I need to build up a string for the profile name with an XML file extension. I use the Join-Path cmdlet and choose the profile folder, and I create a file name based on the profile name with the .xml file extension. This is shown here:

$HashPath =

  Join-Path -Path $profileFolder -ChildPath (“{0}.{1}” -f $profileName,”XML”)

I want to see if there is already an XML representation of the file hash. If there is, I will read it. Then I will get a new file hash for the current profile, and use Compare-Object to examine the hash property. This portion of the function is shown here:

if(Test-Path -Path $HashPath)

   { $oldHash = Import-Clixml $HashPath

     $newHash = Get-FileHash -Path $profile

     $diff = Compare-Object -Property hash -ReferenceObject $oldHash `

     -DifferenceObject $newHash

If there is a difference, I open Windows PowerShell with the –noprofile switch, and I open the current profile in Notepad. In this way, I can easily look at the profile in a safe environment. This script is shown here:

If($diff)

      {

       powershell -noprofile -command “&”Notepad $profile””

When I am done, I delete the old file hash of the profile, and I create a new file hash of the current Windows PowerShell profile. I store the hash in the XML file as shown here:

Remove-Item $HashPath

       Get-FileHash -Path $profile |

       Export-Clixml -Path $HashPath -Force }

   }

If there is no stored file hash, I simply take a file hash and store it in the XML file. It will be referenced the next time I call the function:

  Else { Get-FileHash -Path $profile |

       Export-Clixml -Path $HashPath -Force }

The complete function is shown here:

#requires -version 4.0

Function Get-ProfileHash

{

 $profileName = ([system.io.fileinfo](Split-Path $profile -Leaf)).basename

 $profileFolder = Split-Path $profile -Parent

 $HashPath =

  Join-Path -Path $profileFolder -ChildPath (“{0}.{1}” -f $profileName,”XML”)

 if(Test-Path -Path $HashPath)

   { $oldHash = Import-Clixml $HashPath

     $newHash = Get-FileHash -Path $profile

     $diff = Compare-Object -Property hash -ReferenceObject $oldHash `

     -DifferenceObject $newHash

     If($diff)

      {

       powershell -noprofile -command “&”Notepad $profile””

       Remove-Item $HashPath

       Get-FileHash -Path $profile |

       Export-Clixml -Path $HashPath -Force }

   }

 Else { Get-FileHash -Path $profile |

       Export-Clixml -Path $HashPath -Force }

}