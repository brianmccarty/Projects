$user = "admin"
$pass = "admin"
$pair = "${user}:${pass}"
$pooluri = "http://192.168.7.10:8888/"
#Encode the string to the RFC2045-MIME variant of Base64, except not limited to 76 char/line.

$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
#Create the Auth value as the method, a space, and then the encoded pair Method Base64String

$basicAuthValue = "Basic $base64"
#Create the header Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==

$headers = @{
	Authorization = $basicAuthValue
}

#Invoke the web-request
$pool_jet_off = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=aux1&value=0" -Headers $headers
$pool_jet_on = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=aux1&value=1" -Headers $headers

$pool_wf_off = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=aux2&value=0" -Headers $headers
$pool_wf_on = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=aux2&value=1" -Headers $headers

$pool_spa_lt_off = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=aux3&value=0" -Headers $headers
$pool_spa_lt_on = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=aux3&value=1" -Headers $headers

$pool_pl_lt_off = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=aux4&value=0" -Headers $headers
$pool_pl_lt_on = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=aux4&value=1" -Headers $headers

$pool_pump_off = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=pump&value=0" -Headers $headers
$pool_pump_on = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=pump&value=1" -Headers $headers

$pool_spa_mode_off = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=spa&value=0" -Headers $headers
$pool_spa_mode_on = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=spa&value=1" -Headers $headers

$pool_pool_heat_off = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=poolht&value=0" -Headers $headers
$pool_pool_heat_on = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=poolht&value=1" -Headers $headers

$pool_spa_heat_off = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=spaht&value=0" -Headers $headers
$pool_spa_heat_on = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=spaht&value=1" -Headers $headers

<#
$poolax5soff = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=aux5&value=0" -Headers $headers #aux5
$autelisjetsoff = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=aux6&value=0" -Headers $headers #nothing
$autelisjetsoff = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=pumplo&value=0" -Headers $headers #nothing
$autelisjetsoff = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=waterfall&value=0" -Headers $headers #nothing
$autelisjetsoff = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=poolht2&value=0" -Headers $headers #nothing
$autelisjetsoff = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=solarht&value=0" -Headers $headers #nothing
#>

<#
$waterfallon = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=aux2&value=1" -Headers $headers
$waterfalloff = Invoke-WebRequest -uri "http://192.168.7.10:8888/set.cgi?name=aux2&value=0" -Headers $headers
#>

<#
[xml]$poolstatus = Invoke-WebRequest -uri "http://192.168.7.10:8888/status.xml" -Headers $headers
$poolstatus
$poolstatus.response
$poolstatus.response.equipment
$poolstatus.response.equipment.aux2
$poolstatus.response.temp
#>

<#
poolsp    : 76   #pool set point
poolsp2   : 60   #nothing
spasp     : 102  #spa set point
pooltemp  : 78   #pool tempurature
spatemp   : 80   #spa tempurature
airtemp   : 80   #air tempurature
solartemp : 0    #nothing
tempunits : F    #units
#>