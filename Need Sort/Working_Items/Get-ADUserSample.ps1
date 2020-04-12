get-aduser –filter * -Properties * | where distinguishedname -like "*CPI Users*" | select * | ogv
