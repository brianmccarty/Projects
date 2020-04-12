# Get the System date and format it to the Evernote expected format
$Cur_Date = Get-Date -UFormat "%Y%m%dT%H%M%SZ"
# Set the input directory, output file and directory
$out_file = "C:\Temp\evernote\Evernote.enex"
$input_folder = "C:\Temp\evernote_working"
# Create an LFCR variable as this doesn't work if just injected into a string
$lfcr = "`r`n"
$tag_info = "PowerShell"

# time to declare the evernote exterior XML wrappers
$pre_file = "<?xml version='1.0' encoding='UTF-8'?>" + $lfcr + "<!DOCTYPE en-export SYSTEM 'http://xml.evernote.com/pub/evernote-export.dtd'>" + $lfcr + "<en-export export-date='$Cur_Date' application='Evernote/Windows' version='3.5'>"
$post_file = "</en-export>"
$pre_title = "<note><title>"
$post_title = "</title><content><![CDATA[<?xml version='1.0' encoding='UTF-8'?>" + $lfcr + "<!DOCTYPE en-note SYSTEM 'http://xml.evernote.com/pub/enml2.dtd'>"
$pre_note = $lfcr + $lfcr + "<en-note>"
$post_note = "</en-note>]]></content><created>$Cur_Date</created><updated>$Cur_Date</updated><tag>$tag_info</tag></note>"

#Write the initial file header to the output file
$pre_file | out-File $out_file -encoding ASCII

# Import the file list into the script for processing
$files=get-childitem c:\temp\evernote_working\* -Name -Include "*.txt"

# Loop iteration through all files in the input directory
foreach ($file in $files) {
# Remove the '.txt' file extension from the end of the file and assign it to the title of the note
$Title = $file.TrimEnd(".txt")
#convert the content of the input file by adding a <br/> tag to the end of each file and then build the content of the note from the file content
$Content_initial = (Get-Content "$input_folder\$file") | foreach-object {$_ + "<br/>"}
$Content = $Content_initial | ForEach-Object {$_ -replace "&", "and"}
#Build the note content before appending to output file
$msg = $pre_title + $Title + $post_title + $pre_note + $Content + $post_note + $lfcr
# Append note content to output file
$msg | out-File $out_file -append -encoding ASCII
}
# Append the required endfile XML wrapper to the output
$post_file  | out-File $out_file -append -encoding ASCII
del C:\Temp\evernote_working\*.*
