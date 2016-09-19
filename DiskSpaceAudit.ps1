##############

# Author        : Baskar Lingam Ramachandran (B.Ramachandran@iaea.org)
# Created Date  : 19th Sept 2016

##############

function Send-Mail
{
    Param ([string]$serverName, [string]$DriveName, [string]$FreeSpace)
    $SMTPServer = "blahblahblah"
    $SMTPPort = "i_cant_tell"
    $from = "DoesNotMatter"
    $to = "DoYouWantToKnow"
    $Subject = "ATTENTION NEEDED: Disk Space issue in $serverName"
    $body = "I, DISK $DriveName in $serverName have only $FreeSpace GB free space. Please clean me up."
    Send-MailMessage -From $from -To $to -Subject $Subject -Body $body -SmtpServer $SMTPServer
}

function Send-MailNoAction
{
    Param ([string]$serverName, [string]$DriveName, [string]$FreeSpace)
    $SMTPServer = "blahblahblah"
    $SMTPPort = "i_cant_tell"
    $from = "DoesNotMatter"
    $to = "DoYouWantToKnow"
    $Subject = "ATTENTION not NEEDED: Disk Space usage in $serverName"
    $body = "I, DISK $DriveName in $serverName have $FreeSpace GB of enough free space. Relax."
    Send-MailMessage -From $from -To $to -Subject $Subject -Body $body -SmtpServer $SMTPServer
}

$server = $env:computername
$Drive = get-wmiobject win32_logicaldisk -Filter "DriveType='3'" | Select-Object Size, FreeSpace, DeviceID
$count = $Drive.Count
for($i = 0; $i -lt $count; $i++)
{
    $freespace = $Drive[$i].FreeSpace/1GB
    $id = $Drive[$i].DeviceId
    if($freespace -lt 10)
    {
        Send-Mail -serverName $server -DriveName $id -FreeSpace $freespace
    }
    else
    {
        Send-MailNoAction -serverName $server -DriveName $id -FreeSpace $freespace
    }
}
