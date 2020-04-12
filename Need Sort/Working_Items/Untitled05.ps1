Get-ChildItem z:\* -Recurse -force | Select LastWriteTime,Name,@{Name=size(MB);Expression={{0:N1} -f($_.length/1mb)}} | Format-Table -AutoSize


,@{Name=�freespace(GB);Expression={{0:N1}� -f ($_.freespace/1gb)}} | Format-Table -AutoSize