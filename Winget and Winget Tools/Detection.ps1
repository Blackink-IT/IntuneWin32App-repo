#Set error action
$ErrorActionPreference = "SilentlyContinue"

try{
    $Module = "WingetTools"
    # Check if WingetTools is installed and needs updated
    # Check if WingetTools needs to be upgraded
    $updateModule = Get-Module -Name $Module -ListAvailable
    if($updateModule){
        Write-Host "$Module is already installed. Checking to see if it needs updated.."
        if($updateModule.Version -ne (Get-InstalledModule -Name $Module).Version){
            Write-Host "$Module needs to be upgraded. Exiting with 1..."
            Stop-Transcript
            [System.Environment]::Exit(1)
        }
        Write-Host "$Module is up to date. Importing the module..."
        #Import Winget module
        Import-Module -Name $Module -Force
        #Test if WinGet is installed and up to date
        Write-Host "$Module is imported. Testing if WinGet is missing or needs an update..."
        $TestWGVersion = Test-WGVersion -Quiet
        Write-Host "Test-WGVersion results: $TestWGVersion"
        if(($TestWGVersion) -or ($null -eq $TestWGVersion)){
            Write-Host "WinGet is either not installed or not up to date. Exiting with 1..."
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
