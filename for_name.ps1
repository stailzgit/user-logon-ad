param ($user)
$user = "станислав"

function GetLogonsUser($userName) {
  $result = ((get-aduser -Filter "(Name -like '*$userName*')" -Properties info).info).split("#")
  for ($i = 0; $i -lt $result.Count; $i += 1) {
    "$i) $($result[$i])"
  }
}

$listUsers = (Get-AdUser -Filter "(Name -like '*$user*')" -properties Name).Name


$countSearch = $listUsers.Count

if ($countSearch -eq 0) {
  "Not found users - $user"
}
elseif ($countSearch -eq 1) {
  GetLogonsUser -userName ($listUsers)
}
else {
  for ($i = 1; $i -le $listUsers.Count; $i += 1) {
    "$i) " + $listUsers[$i - 1]
  }

  $userNum = Read-Host -Prompt 'Input user number'

  GetLogonsUser -userName $listUsers[$userNum - 1]
}




