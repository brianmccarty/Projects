$GroupList = Get-ADGroup -Filter * -Properties Name, DistinguishedName, `
        GroupCategory, GroupScope, whenCreated, whenChanged, member, `
        memberOf, sIDHistory, SamAccountName, Description |            
    Select-Object Name, DistinguishedName, GroupCategory, GroupScope, `
        whenCreated, whenChanged, member, memberOf, SID, SamAccountName, `
        Description, `
        @{name='MemberCount';expression={$_.member.count}}, `
        @{name='MemberOfCount';expression={$_.memberOf.count}}, `
        @{name='SIDHistory';expression={$_.sIDHistory -join ','}}, `
        @{name='DaysSinceChange';expression=`
            {[math]::Round((New-TimeSpan $_.whenChanged).TotalDays,0)}} |            
    Sort-Object Name            
            
$GroupList |            
    Select-Object Name, SamAccountName, Description, DistinguishedName, `
        GroupCategory, GroupScope, whenCreated, whenChanged, DaysSinceChange, `
        MemberCount, MemberOfCount, SID, SIDHistory |            
    Export-CSV .\GroupList.csv -NoTypeInformation