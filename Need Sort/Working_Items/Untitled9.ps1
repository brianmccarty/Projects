function large_files 
{ 
Get-ChildItem c:\ -recurse | Where-Object {$_.length -gt 100MB -and !$_.PSiscontainer} 
} 
 
large_files | Out-GridView