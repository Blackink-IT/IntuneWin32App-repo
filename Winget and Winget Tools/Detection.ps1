#Set error action
$ErrorActionPreference = "SilentlyContinue"
#Transcript location
$TranscriptPath = "C:\Windows\Temp\PS.Transcript.Detection.WinGet-WinGetTools.log"
#Start transcript
Try{Start-Transcript -Path $TranscriptPath -Force -ErrorAction Stop}catch{Start-Transcript -Path $TranscriptPath -Force}
try{
    $Module = "WingetTools"
    # Check if WingetTools is installed
    if(Get-Module -Name $Module -ListAvailable){
        Write-Host "$Module is already installed. Checking to see if it needs updated.."
        # Check if WingetTools needs to be upgraded
        $updateModule = Get-Module -Name $Module -ListAvailable
        if($updateModule.Version -lt (Get-InstalledModule -Name $Module).Version){
            Write-Host "$Module needs to be upgraded. Exiting with 1..."
            Stop-Transcript
            [System.Environment]::Exit(1) 
        }
        $TestWGVersion = Test-WGVersion -Quiet
        if(($TestWGVersion) -or ($null -eq $TestWGVersion)){
            if($TestWGVersion){
                Write-Host "WinGet is not up to date. Exiting with 1..."
            }else{
                Write-Host "WinGet is not installed. Exiting with 1..."
            }
            Stop-Transcript
            [System.Environment]::Exit(1) 
        }else{
            Write-Host "WinGet is installed and up to date. Exiting with 0"
            Stop-Transcript
            [System.Environment]::Exit(0) 
        }
    }else {
        Write-Host "$Module is not installed. Exiting with 1..."
        Stop-Transcript
        [System.Environment]::Exit(1) 
    }
}catch{
    [System.Environment]::Exit(1)
}