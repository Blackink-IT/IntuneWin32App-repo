try{
    $Module = "WingetTools"
    # Check if WingetTools is installed and needs updated
    $updateModule = Get-Module -Name $Module -ListAvailable
    if($updateModule){
        Write-Host "$Module is already installed. Checking to see if it needs updated.."
        if($updateModule.Version -ne (Get-InstalledModule -Name $Module).Version){
            Write-Host "$Module needs to be upgraded. Exiting with 1..."
            Stop-Transcript
            [System.Environment]::Exit(1)
        }
        Write-Host "$Module is up to date. Importing the module..."
        #Check to see if winget exists in this directory C:\Program Files\WindowsApps
        $Dir = dir "C:\Program Files\WindowsApps" | Where-Object{$_.Name -like "Microsoft.DesktopAppInstaller_*"}
        $Dir = ($Dir | Where-Object{$_.Name -like "*x64*"}).FullName
        Write-Host "This is the directory we found with a WinGet folder. Checking to see if winget.exe exists within this dir: $Dir"
        Write-Host
        if(Test-Path -Path "$Dir\winget.exe" -PathType Leaf){
            Write-Host "WinGet is installed and up to date. Exiting with 0"
            Stop-Transcript
            [System.Environment]::Exit(0)
        }else{
            Write-Host "WinGet is not installed. Exiting with 1..."
            Stop-Transcript
            [System.Environment]::Exit(1)
        }
    }else {
        Write-Host "$Module is not installed. Exiting with 1..."
        Stop-Transcript
        [System.Environment]::Exit(1)
    }
}catch{
    [System.Environment]::Exit(1)
}
