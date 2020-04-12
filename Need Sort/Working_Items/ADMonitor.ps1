
  $email="jswenson@esd.wa.gov"
  $smtp="smtp.josh.net"

  $ew = new-object system.management.ManagementEventWatcher                                                                           
  $ew.query = "Select * From __InstanceCreationEvent Where TargetInstance ISA 'Win32_NTLogEvent'"                                 
  while (!$x){                                                                                               
    $e = $ew.WaitForNextEvent()  
    switch ($e.targetinstance) 
      { 
      {$_.message -like "*locked out*"} {
        $subject="User Locked - $($e.targetinstance.insertionstrings[0]) - By $($e.targetinstance.insertionstrings[1]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        }  
      {$_.message -like "*unlocked*"} {
        $subject="User UnLocked - $($e.targetinstance.insertionstrings[0]) - By $($e.targetinstance.insertionstrings[4]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        }
      {$_.message -like "*user account was created*"} {
        $reset="no";$enabled="no"
        $subject="User Created - $($e.targetinstance.insertionstrings[0]) - By $($e.targetinstance.insertionstrings[4]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        }  
      {$_.message -like "*user account was deleted*"} {
        $subject="User Deleted - $($e.targetinstance.insertionstrings[0]) - By $($e.targetinstance.insertionstrings[4]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        }
      {$_.message -like "*computer account was created*"} {
        $reset="no";$enabled="no"
        $subject="Computer Created - $($e.targetinstance.insertionstrings[0] -replace `"\`$`",`"`") - By $($e.targetinstance.insertionstrings[4]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        }  
      {$_.message -like "*computer account was deleted*"} {
        $subject="Computer Deleted - $($e.targetinstance.insertionstrings[0] -replace `"\`$`",`"`") - By $($e.targetinstance.insertionstrings[4]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        } 
      {$_.message -like "*group was created*"} {
        $subject="Group Created - $($e.targetinstance.insertionstrings[0]) - By $($e.targetinstance.insertionstrings[4]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        }  
      {$_.message -like "*group was deleted*"} {
        $subject="Group Deleted - $($e.targetinstance.insertionstrings[0]) - By $($e.targetinstance.insertionstrings[4]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        } 
      {$_.message -like "*member was added*"} {
        $member= $e.targetinstance.insertionstrings[0] | ForEach-Object { [regex]::Match($_,'([^=]+),OU=').Groups[1].Value } | foreach-object {$_ -replace "\\", ""} 
        $subject="Member Added - ($member - $($e.targetinstance.insertionstrings[2])) - By $($e.targetinstance.insertionstrings[6]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        }  
      {$_.message -like "*member was removed*"} {
        $member= $e.targetinstance.insertionstrings[0] | ForEach-Object { [regex]::Match($_,'([^=]+),OU=').Groups[1].Value } | foreach-object {$_ -replace "\\", ""} 
        $subject="Member Removed - ($member - $($e.targetinstance.insertionstrings[2])) - By $($e.targetinstance.insertionstrings[6]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        }  
      {($_.message -like "*directory service object was created*") -and ($_.message -like "*organizationalUnit*")} {
        $subject="OU Created - $($($e.targetinstance.insertionstrings[8]) | ForEach-Object { [regex]::Match($_,'OU=([^,]+)').Groups[1].Value }) - By $($e.targetinstance.insertionstrings[3]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        } 
      {($_.message -like "*directory service object was deleted*") -and ($_.message -like "*organizationalUnit*")} {
        $subject="OU Deleted - $($($e.targetinstance.insertionstrings[8]) | ForEach-Object { [regex]::Match($_,'OU=([^,]+)').Groups[1].Value }) - By $($e.targetinstance.insertionstrings[3]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        } 
      {$_.message -like "*directory service object was moved*"} {
        $subject="Object Moved - $($e.targetinstance.insertionstrings[8] | ForEach-Object { [regex]::Match($_,'([^=]+),OU=').Groups[1].Value }) - By $($e.targetinstance.insertionstrings[3]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        } 
      {($_.message -like "*user account was enabled*") -and ($($e.targetinstance.insertionstrings[0]) -notmatch "\`$")} {
        $subject="User Enabled - $($e.targetinstance.insertionstrings[0]) - By $($e.targetinstance.insertionstrings[4]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        if ($enabled -ne "no"){send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp};$enabled="yes"
        } 
      {($_.message -like "*user account was disabled*") -and ($($e.targetinstance.insertionstrings[0]) -notmatch "\`$")} {
        $subject="User Disabled - $($e.targetinstance.insertionstrings[0]) - By $($e.targetinstance.insertionstrings[4]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        } 
      {($_.message -like "*user account was enabled*") -and ($($e.targetinstance.insertionstrings[0]) -match "\`$")} {
        $subject="Computer Enabled - $($e.targetinstance.insertionstrings[0] -replace `"\`$`",`"`") - By $($e.targetinstance.insertionstrings[4]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        if ($enabled -ne "no"){send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp};$enabled="yes"
        } 
      {($_.message -like "*user account was disabled*") -and ($($e.targetinstance.insertionstrings[0]) -match "\`$")} {
        $subject="Computer Disabled - $($e.targetinstance.insertionstrings[0] -replace `"\`$`",`"`") - By $($e.targetinstance.insertionstrings[4]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        } 
      {($_.message -like "*reset an account*") -and ($($e.targetinstance.insertionstrings[0]) -notmatch "\`$")} {
        $subject="Password Reset - $($e.targetinstance.insertionstrings[0] -replace `"\`$`",`"`") - By $($e.targetinstance.insertionstrings[4]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        if ($reset -ne "no"){send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp};$reset="yes"
        } 
      {($_.message -like "*directory service object was created*") -and ($_.message -like "*groupPolicyContainer*")} {
        $modified="no"
        $gponame=$([ADSI] "LDAP://$($e.targetinstance.insertionstrings[8])").displayname
        $subject="GPO Created - ($gponame) - By $($e.targetinstance.insertionstrings[3]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        } 
      {($_.message -like "*directory service object was deleted*") -and ($_.message -like "*groupPolicyContainer*")} {
        $gponame=$([ADSI] "LDAP://esd1gcspotc02/$($e.targetinstance.insertionstrings[8])").displayname
        $subject="GPO Deleted - ($gponame) - By $($e.targetinstance.insertionstrings[3]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        } 
      {($_.message -like "*directory service object was modified*") -and ($_.message -like "*groupPolicyContainer*") -and ($_.message -like "*versionNumber*") -and ($_.message -like "*Value Added*")} {
        $gponame=$([ADSI] "LDAP://$($e.targetinstance.insertionstrings[8])").displayname
        $subject="GPO Modifed - ($gponame) - By $($e.targetinstance.insertionstrings[3]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        if ($modified -ne "no"){send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp};$modified="yes"
        } 
      {($_.message -like "*directory service object was modified*") -and ($_.message -like "*gpLink*") -and ($_.message -like "*Value Added*")} {
        $gponame=$([ADSI] "LDAP://$($e.targetinstance.insertionstrings[8])").displayname
        $subject="GPO Link Changed - ($($e.targetinstance.insertionstrings[8])) - By $($e.targetinstance.insertionstrings[3]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
        } 
#      {($_.message -like "*directory service object was modified*") -and ($_.message -like "*description*") -and ($_.message -like "*Value Added*") -and ($_.message -notlike "*container*")} {
#        $user= $e.targetinstance.insertionstrings[8] | % { [regex]::Match($_,'([^=]+),OU=').Groups[1].Value } | foreach-object {$_ -replace "\\", ""} 
#        $subject="Description Changed - ($user) - By $($e.targetinstance.insertionstrings[3]) - Event $($_.eventcode)";$body="$($_.computername) `n$($_.message)"
#        send-mailmessage -from $email -to $email -subject $subject -body $body -smtpserver $smtp
#        } 
      }
    }

#        write-host "0:$($e.targetinstance.insertionstrings[0]),1:$($e.targetinstance.insertionstrings[1]),2:$($e.targetinstance.insertionstrings[2]),3:$($e.targetinstance.insertionstrings[3]),4:$($e.targetinstance.insertionstrings[4]),5:$($e.targetinstance.insertionstrings[5]),6:$($e.targetinstance.insertionstrings[6]),7:$($e.targetinstance.insertionstrings[7]),8:$($e.targetinstance.insertionstrings[8]),9:$($e.targetinstance.insertionstrings[9]),10:$($e.targetinstance.insertionstrings[10]),11:$($e.targetinstance.insertionstrings[11]),12:$($e.targetinstance.insertionstrings[12]),13:$($e.targetinstance.insertionstrings[13]),14:$($e.targetinstance.insertionstrings[14]),15:$($e.targetinstance.insertionstrings[15]),16:$($e.targetinstance.insertionstrings[16]),17:$($e.targetinstance.insertionstrings[17]),18:$($e.targetinstance.insertionstrings[18]),19:$($e.targetinstance.insertionstrings[19]),20:$($e.targetinstance.insertionstrings[20]) `n Message: $($_.message)"


