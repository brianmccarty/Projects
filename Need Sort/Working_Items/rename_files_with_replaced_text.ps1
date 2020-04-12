Get-ChildItem -Filter "*.atblaw.v2*" -Recurse | Rename-Item -NewName {$_.name -replace '.atblaw.v2','' }
