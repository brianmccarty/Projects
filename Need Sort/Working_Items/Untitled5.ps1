Start-ADSyncSyncCycle -PolicyType Initial

Get-ADSyncScheduler

Set-ADSyncScheduler -SyncCycleEnabled $True