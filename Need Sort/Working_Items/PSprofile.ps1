if (((Get-Date).DayofWeek) -eq 'Monday') 
    {$Sapi = New-Object -ComObject sapi.spvoice
    #Switch Voice from David to Zira
    $Sapi.Voice = $Sapi.GetVoices().Item(2)
    #State what "day of the week" shuffle it is
    $Sapi.Speak("Time for the $((Get-Date).DayofWeek) shuffle")
    $Sapi.Voice = $Sapi.GetVoices().Item(0)
    $Sapi.Rate = -2
    #State last half of greeting
    $Sapi.Speak("Fuck yeah, Tuesdays")}

elseif (((Get-Date).DayofWeek) -eq 'Tuesday') 
    {$Sapi = New-Object -ComObject sapi.spvoice
    $Sapi.Voice = $Sapi.GetVoices().Item(2)
    $Sapi.Speak("Second floor, hardware, childrens wear, ladies lonjeray. O. Good morning Mr Soory. Going. down?")
    $Sapi.Voice = $Sapi.GetVoices().Item(0)
    #Slow the rate of speach down
    $Sapi.Rate = -3
    #State last half of greeting
    $Sapi.Speak("Hm hm hm hm")}

elseif (((Get-Date).DayofWeek) -eq 'Wednesday') 
    {$Sapi = New-Object -ComObject sapi.spvoice
    #Switch Voice from David to Zira
    $Sapi.Voice = $Sapi.GetVoices().Item(2)
    #State what "day of the week" shuffle it is
    $Sapi.Speak("Time for the $((Get-Date).DayofWeek) shuffle")
    #Switch the voice back to David
    $Sapi.Voice = $Sapi.GetVoices().Item(0)
    #Slow the rate of speach down
    $Sapi.Rate = -2
    #State last half of greeting
    $Sapi.Speak("Holy Shit its only Wednesday")}

elseif (((Get-Date).DayofWeek) -eq 'Thursday') 
    {$Sapi = New-Object -ComObject sapi.spvoice
    #Switch Voice from David to Zira
    $Sapi.Voice = $Sapi.GetVoices().Item(1)
    #State what "day of the week" shuffle it is
    $Sapi.Speak("baba booey")
    #Switch the voice back to David
    $Sapi.Voice = $Sapi.GetVoices().Item(0)
    #Slow the rate of speach down
    $Sapi.Rate = -2
    #State last half of greeting
    $Sapi.Speak("Rise up, gather round, rock this place, to the ground")}

elseif (((Get-Date).DayofWeek) -eq 'Friday') 
    {$Sapi = New-Object -ComObject sapi.spvoice
    #Switch Voice from David to Zira
    $Sapi.Voice = $Sapi.GetVoices().Item(2)
    #State what "day of the week" shuffle it is
    $Sapi.Speak("Time for the $((Get-Date).DayofWeek) shuffle")
    #Switch the voice back to David
    $Sapi.Voice = $Sapi.GetVoices().Item(0)
    #Slow the rate of speach down
    $Sapi.Rate = -2
    #State last half of greeting
    $Sapi.Speak("Fuck yeah, Tuesdays")}