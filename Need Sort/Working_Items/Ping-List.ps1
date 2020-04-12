'127.0.0.1', '192.168.100.30' | `
Foreach-Object { $ip = $_; `
try { [System.Net.DNS]::GetHostByAddress($_) } `
catch { Write-Warning "Unable to resolve $ip. Reason: $_" } }