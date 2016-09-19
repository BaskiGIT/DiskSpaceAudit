$Drive = get-wmiobject win32_logicaldisk -Filter "DriveType='3'" -ComputerName FQDN_of_server | Select-Object Size, FreeSpace, DeviceID
# $Drive
# $Drive[0].FreeSpace
$count = $Drive.Count
$count
for($i = 0; $i -lt $count; $i++)
{
    $freespace = $Drive[$i].FreeSpace/1GB
    $id = $Drive[$i].DeviceId
    if($freespace -gt 10)
    {
        Write-Host "No alert needed for $id"
    }
    else
    {
        Write-Host "Alert needed for $id"
    }
}

function Send_Mail
{
    Param ([string]$serverName, [string]$DriveName, [string]$FreeSpace)
    $SMTPServer = "blahblahblah"
    $SMTPPort = "i-cant_tell"
    $from = "do_you_need_it"
    $to = "you_know_it"
    $Subject = "ATTENTION NEEDED: Disk Space issue in $serverName"
    $body = "DISK $DriveName in $serverName has $FreeSpace GB free space only"
    Send-MailMessage -From $from -To $to -Subject $Subject -Body $body -SmtpServer $SMTPServer
}
