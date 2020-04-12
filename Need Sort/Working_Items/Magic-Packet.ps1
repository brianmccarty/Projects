$mac = [byte[]](0xE0, 0xCB, 0x4E, 0x83, 0x93, 0x7F)

$UDPclient = new-Object System.Net.Sockets.UdpClient
$UDPclient.Connect(([System.Net.IPAddress]::Broadcast),4000)
$packet = [byte[]](,0xFF * 102)
6..101 |% { $packet[$_] = $mac[($_%6)]}
$UDPclient.Send($packet, $packet.Length)