Function Get-Fib ($n) {
    $current = 0;
    $previous = 1; 
    while ($current -lt $n) {
        “{0:N0}” -f $current;
        $current,$previous = ($current + $previous),$current
        }
}
