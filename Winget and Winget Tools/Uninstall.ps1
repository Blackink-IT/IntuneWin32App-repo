#ID of WinGet
$ID = "Microsoft.Winget.Source_8wekyb3d8bbwe"

try{
    Write-Host "Attempting to uninstall winget with this ID now: $ID"
    winget uninstall -h --silent --id $ID
    Stop-Transcript
    [System.Environment]::Exit(0)
}catch{
    [System.Environment]::Exit(1)
}
