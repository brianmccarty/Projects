# ----------------------------------------------------------------------------------------------------------------- 
# Get-MyDocumentsSize.ps1 
# ed wilson, msft, 7/13/2009 
#  
# Keywords: [environmnet], GetFolderPath method, Special folders, specialfolder, 
# admin constant, measure-object, if, format specifier 
# 
# This script uses the getFolderPath static method from the system.environment class 
# to retrieve the path to the mydocuments folder, it then uses the get-childitem cmdlet to 
# retrieve the files in the folder It then uses the measure-object cmdlet to calculate the size 
# of the files in the folder. 
# Can get the special folders by using the [environment+SpecialFolder] enumeration. Use the static 
# getNames method from system.enum. This is done like this: 
# [enum]::GetNames([environment+SpecialFolder]) 
# ----------------------------------------------------------------------------------------------------------------------- 
$path = [environment]::GetFolderPath([environment+SpecialFolder]::MyDocuments) 
 $totalSize = Get-ChildItem -path $path -recurse -errorAction "SilentlyContinue" | 
 Measure-Object -property length -sum 
 IF($totalSIze.Sum -ge 1GB) 
   { 
      "{0:n2}" -f  ($totalSize.sum / 1GB) + " GigaBytes" 
   } 
 ELSEIF($totalSize.sum -ge 1MB) 
    { 
      "{0:n2}" -f  ($totalSize.sum / 1MB) + " MegaBytes" 
    } 
 ELSE 
    { 
      "{0:n2}" -f  ($totalSize.sum / 1KB) + " KiloBytes" 
    } 