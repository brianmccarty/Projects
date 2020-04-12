$containers = Get-ChildItem -path $Path -recurse | Where-object {$_.psIscontainer}


I thought I was getting all the containers with  $containers = Get-ChildItem -path $Path -recurse | ? {$_.psIscontainer -eq $true}, but it appears to return back just subdirectories of my $Path. I really want $containers to contain $Path and its sub-directories. I tried this:

$containers = Get-Item -path $Path | ? {$_.psIscontainer -eq $true}
$containers += Get-ChildItem -path $Path -recurse | ? {$_.psIscontainer -eq $true}
But it does not let me do this. Am I using Get-ChildItem wrong, or how do I get $containers to include the $Path and its $subdirectories by combining a Get-Item and Get-ChildItem with -recurse?

powershell
shareimprove this question
edited Aug 13 '12 at 20:15

Nooshin
16227
asked Aug 13 '12 at 19:53

user372429
76312
add a comment
3 Answers
active oldest votes
up vote
3
down vote
In your first call to get-item you are not storing the results in an array (because it's only 1 item). This means you can't append the array to it in your get-childitem line. Simply force your containers variable to be an array by wrapping the result in an @() like this:

$containers = @(Get-Item -path $Path | ? {$_.psIscontainer})
$containers += Get-ChildItem -path $Path -recurse | ? {$_.psIscontainer}
shareimprove this answer
answered Aug 13 '12 at 20:37

zdan
18.1k24159
  	 	
This seemed to work. – user372429 Aug 14 '12 at 18:04
add a comment
up vote
1
down vote
Use Get-Item to get the parent path and Get-ChildItem to get the parent childrens:

$parent = Get-Item -Path $Path
$child = Get-ChildItem -Path $parent -Recurse | Where-Object {$_.PSIsContainer}
$parent,$child
shareimprove this answer
answered Aug 14 '12 at 6:27

Shay Levy
68.3k12110133
  	 	
I tried this with: $containters = $parent,$child, but what you get is $containers = {upgrade},{in,out}--in that, two arrays added to $containers. – user372429 Aug 14 '12 at 13:18 
  	 	
Try: $containers = $child+$parent – Shay Levy Aug 14 '12 at 14:00 
  	 	
@ShayLevy I don't think that will work since you are trying to add an array to a string. But this should: $containers = @($child)+$parent – zdan Aug 14 '12 at 20:25
  	 	
@zdan nor $child or $parent are strings, both contain DirectoryInfo objects. Do you get different results? – Shay Levy Aug 15 '12 at 7:33
add a comment
up vote
0
down vote
The following worked for me:

$containers = Get-ChildItem -path $Path -recurse | Where-object {$_.psIscontainer}
What I end up with is the $path and all sub-directories of $path.

In your example, you have $.psIscontainer but it should be $_.psIscontainer. That might have also been the problem with your command.

shareimprove this answer
answered Aug 13 '12 at 20:04

Nick
2,95311533
  	 	
I have $Path = \\share\place with two subdirectories called in and out for example. When I run your suggestion I still get $containers = {in,out}, not {\\share\place,in,out}. This is confusing. – user372429 Aug 13 '12 at 20:24
  	 	
If you want the full name then you need to select the full name: $containers = Get-ChildItem -path $Path -recurse | Where-object {$_.psIscontainer} | Select-Object FullName – EBGreen Aug 13 '12 at 20:38