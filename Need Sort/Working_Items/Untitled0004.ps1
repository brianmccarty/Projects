BREAK

   1 Get-WindowsUpdateLog                                                                                                                                                
   2 (Get-Content ".\Desktop\WindowsUpdate.log") -notmatch "1600/12/31" | Out-File -Encoding ASCII ".\Desktop\WindowsUpdateCleaned.log"                                  
   3 cd C:\Users\bmccarty                                                                                                                                                
   4 dir                                                                                                                                                                 
   5 cd .\OneDrive                                                                                                                                                       
   6 dir                                                                                                                                                                 
   7 cd .\00-Redirected                                                                                                                                                  
   8 dir                                                                                                                                                                 
   9 cd .\Desktop                                                                                                                                                        
  10 (Get-Content ".\Desktop\WindowsUpdate.log") -notmatch "1600/12/31" | Out-File -Encoding ASCII ".\Desktop\WindowsUpdateCleaned.log"                                  
  11 (Get-Content "WindowsUpdate.log") -notmatch "1600/12/31" | Out-File -Encoding ASCII "WindowsUpdateCleaned.log"                                                      
  12 Get-WindowsUpdateLog                                                                                                                                                
  13 (Get-Content "WindowsUpdate.log") -notmatch "1600/12/31" | Out-File -Encoding ASCII "WindowsUpdateCleaned.log"          