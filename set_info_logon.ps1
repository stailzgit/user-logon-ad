function GetNewLogon {
  $userUS = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")[1]
  $userRU = (get-aduser -Identity $userUS -properties name).name
  $ip = ((ipconfig | findstr [0-9].\.)[0]).Split()[-1]
  $pc = [System.Net.Dns]::GetHostName()
  $date = Get-Date -Format "MM.dd.yyyy-HH:mm"

  $info = "$userRU|$userUS|$ip|$pc|$date"
  return $info
}

function GetNewInfo {
  param ($prevInfo, $newInfo)
  $logonItems = @()

  if ( $null -ne $prevInfo ) {
    $logonItems = $prevInfo.split("#")
  }

  $infoStr = $newInfo

  for ($i = 1; ($i -le 9) -and ($i -le $logonItems.Count); $i += 1) {
    $infoStr += "#" + $logonItems[$i - 1]
  }
  return $infoStr
}

$prevInfo = (get-aduser -Identity s.gorenkov -properties info).info
$newLogon = (GetNewLogon)
$newInfo = (GetNewInfo -prevInfo $prevInfo -newInfo $newLogon)

Set-ADUser s.gorenkov -Replace @{info = $newInfo }

$result = ((get-aduser -Identity s.gorenkov -properties info).info).split("#")
for ($i = 0; $i -lt $result.Count; $i += 1) {
  "$($i)) $($result[$i])"
}