#Vars for transcript
$TranscriptPath = "C:\Windows\Temp\PS.Transcript.Uninstall.WinGet-WinGetTools.log"
$ID = "Microsoft.Winget.Source_8wekyb3d8bbwe"
#Start transcript
Try{Start-Transcript -Path $TranscriptPath -Force -ErrorAction Stop}catch{Start-Transcript -Path $TranscriptPath -Force}
try{
    Write-Host "Attempting to uninstall winget with this ID now: $ID"
    winget uninstall -h --silent --id $ID
    Stop-Transcript
    [System.Environment]::Exit(0)
}catch{
    [System.Environment]::Exit(1)
}