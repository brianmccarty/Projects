1..255 | Foreach-Object { "192.168.100.$_" } | `
Foreach-Object { $ip = $_; `
try { [System.Net.DNS]::GetHostByAddress($_) } catch `
{ Write-Warning "Unable to resolve $ip. Reason: $_" } }