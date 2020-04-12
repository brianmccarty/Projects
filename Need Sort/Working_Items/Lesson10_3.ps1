$ara_procs = Get-Process | sort id

foreach ($proc in $ara_procs)
{
    if ($proc.MainWindowTitle -gt 0)
    {
               $props = [ordered]@{
                 'ID' = $proc.Id;
                 'Process' = $proc.ProcessName;
                 'Main Window Title:' = $proc.MainWindowTitle;
                 'Paged mem:' = $proc.PagedMemorySize;
                 'Peak paged mem:' = $proc.PeakPagedMemorySize;
                 'Virtual mem:' = $proc.VirtualMemorySize;
                 'Peak Virtual mem:' = $proc.PeakVirtualMemorySize;
                 } 
            $obj = New-Object –typename PSObject -Property $props      
            #Write-Output -------------------------------------------
            Write-Output $obj 
    }
    
    else{ Out-Null }
}
