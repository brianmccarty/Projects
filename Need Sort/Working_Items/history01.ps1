
  Id CommandLine                                                                                                                                         
  -- -----------                                                                                                                                         
   1 Get-Alias                                                                                                                                           
   2 Get-Alias | Out-File c:\temp\get-alias.txt                                                                                                          
   3 Get-Alias | Out-File c:\temp\get-alias.csv                                                                                                          
   4 Get-Alias | ConvertTo-Csv C:\temp\get-alias.csv                                                                                                     
   5 Get-Alias | ConvertTo-Csv | out-file C:\temp\get-alias.csv                                                                                          
   6 Get-Alias | ogv                                                                                                                                     
   7 cls                                                                                                                                                 
   8 cd C:\temp                                                                                                                                          
   9 # 1. TESTING: Generate a random, unique source directory, with some test files in it...                                                             
  10 $TestSource = '{0}\{1}' -f $env:temp, [Guid]::NewGuid().ToString();                                                                                 
  11 $TestSource = '{0}\{1}' -f $env:temp, [Guid]::NewGuid().ToString(); -verbose                                                                        
  12 $TestSource = '{0}\{1}' -f $env:temp, [Guid]::NewGuid().ToString();                                                                                 
  13 $TestSource                                                                                                                                         
  14 # 1. TESTING: Generate a random, unique source directory, with some test files in it...                                                             
  15 # 2. TESTING: Create a random, unique target directory...                                                                                           
  16 function Copy-WithProgress {...                                                                                                                     
  17 # 3. Call the Copy-WithProgress function...                                                                                                         
  18 function Copy-WithProgress {...                                                                                                                     
  19 ...                                                                                                                                                 
  20 function Copy-WithProgress {...                                                                                                                     
  21 # 3. Call the Copy-WithProgress function...                                                                                                         
  22 # 3. Call the Copy-WithProgress function...                                                                                                         
  23 # 1. TESTING: Generate a random, unique source directory, with some test files in it...                                                             
  24 # 2. TESTING: Create a random, unique target directory...                                                                                           
  25 # 3. Call the Copy-WithProgress function...                                                                                                         
  26 # 4. Add some new files to the source directory...                                                                                                  
  27 # 5. Call the Copy-WithProgress function (again)...                                                                                                 
  28 Get-NetIPConfiguration                                                                                                                              
  29 Get-NetIPConfiguration | ogv                                                                                                                        
  30 Get-NetIPConfiguration -InterfaceAlias wifi                                                                                                         
  31 Get-NetIPConfiguration -InterfaceAlias 'wifi'                                                                                                       
  32 Get-NetIPConfiguration -InterfaceAlias 'Wi-Fi'                                                                                                      
  33 Get-NetIPConfiguration -InterfaceAlias 'Wi-Fi' -full                                                                                                
  34 Get-NetIPConfiguration -InterfaceAlias 'Wi-Fi' | select *                                                                                           
  35 Get-NetIPConfiguration -InterfaceAlias 'Wi-Fi' | fl                                                                                                 
  36 Get-NetAdapter                                                                                                                                      
  37 Get-NetAdapterStatistics                                                                                                                            
  38 Get-NetAdapter                                                                                                                                      
  39 Get-NetAdapterStatistics                                                                                                                            
  40 Get-NetIPConfiguration -InterfaceAlias 'Wi-Fi'                                                                                                      
  41 Get-NetIPConfiguration -InterfaceAlias 'Wi-Fi' | ogv                                                                                                
  42 Get-NetIPConfiguration -InterfaceAlias 'Ethernet'                                                                                                   
  43 New-NetIPAddress -InterfaceAlias Ethernet -IPAddress 172.18.8.25 -PrefixLength 23 -DefaultGateway 172.16.0.1                                        
  44 New-NetIPAddress -InterfaceAlias Ethernet -IPAddress 172.18.8.25 -PrefixLength 23 -DefaultGateway 172.18.8.1                                        
  45 New-NetIPAddress -InterfaceAlias Ethernet -IPAddress 172.18.8.25 -PrefixLength 23 -DefaultGateway 172.16.0.1 -foce                                  
  46 New-NetIPAddress -InterfaceAlias Ethernet -IPAddress 172.18.8.25 -PrefixLength 23 -DefaultGateway 172.16.0.1 -force                                 
  47 Get-NetIPConfiguration -InterfaceAlias 'Ethernet'                                                                                                   
  48 Test-NetConnection                                                                                                                                  
  49 tnc                                                                                                                                                 
  50 tnc 8.8.8.8                                                                                                                                         
  51 tnc -TraceRoute                                                                                                                                     
  52 tnc | gm                                                                                                                                            
  53 tnc cpi.ncloud.cpisolutions.com -port 443                                                                                                           
  54 tnc cpi.ncloud.cpisolutions.com -port 444                                                                                                           
  55 Restart-Service spooler                                                                                                                             
  56 Get-Service | ogv                                                                                                                                   
  57 Get-Service                                                                                                                                         
  58 Rename-Computer apple -whatif                                                                                                                       
  59 add-computer -DomainName cpisolutions.local                                                                                                         
  60 cls                                                                                                                                                 
  61 Test-ComputerSecureChannel -Credential domain\admin -Repair                                                                                         
  62 Set-NetFirewallProfile -Profile domain,public,private -Enabled false                                                                                
  63 Set-NetFirewallProfile -Profile domain,public,private -Enabled true                                                                                 
  64 function get-openfiles{...                                                                                                                          
  65 get-openfiles                                                                                                                                       
  66 get-openfiles -verbose                                                                                                                              
  67 get-openfiles -verbose                                                                                                                              
  68 get-openfiles -computername localhost -verbose                                                                                                      
  69 get-openfiles -computername localhost                                                                                                               
  70 get-openfiles -computername localhost                                                                                                               
  71 cls                                                                                                                                                 
  72 function get-openfiles{...                                                                                                                          
  73 get-openfiles                                                                                                                                       
  74 get-openfiles    -verbose                                                                                                                           
  75 get-openfiles    verbose                                                                                                                            
  76 get-openfiles localhost verbose                                                                                                                     
  77 get-openfiles localhost -verbose                                                                                                                    
  78 function get-openfiles{...                                                                                                                          
  79 function get-openfiles{...                                                                                                                          
  80 get-openfiles localhost                                                                                                                             
  81 get-openfiles localhost                                                                                                                             
  82 function get-openfiles{...                                                                                                                          
  83 get-openfiles localhost                                                                                                                             


