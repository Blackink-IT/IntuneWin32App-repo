$PackageName = "WindowsPackageManager"
$MSIXBundle = "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
$URL_msixbundle = "https://aka.ms/getwinget"

function DownloadJob(){
    param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$URL,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Destination
    )
    Write-Host "Downlaoding from: $URL"
    Write-Host "Downlaoding to: $Destination"
    Start-Job -ArgumentList $URL,$Destination -ScriptBlock {
        Param($URL,$Destination)
        Invoke-WebRequest -Uri $URL -OutFile $Destination
    } | Wait-Job
}

#Vars for transcript
$TranscriptPath = "C:\Windows\Temp\PS.Transcript.Install.WinGet-WinGetTools.log"
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
            Write-Host "$Module needs to be upgraded. Upgrading now..."
            Update-Module -Name $Module -Force
        }
    }else {
        Write-Host "$Module is not installed. Installing now..."
        Install-Module -Name $Module -Force        
    }
    
    #Download item
    New-Item -Path "C:\Windows\Temp\WinGet\$MSIXBundle" -ItemType Directory -Force -Confirm:$false
    DownloadJob -URL $URL_msixbundle -Destination "C:\Windows\Temp\WinGet\$MSIXBundle"


    #Install
    Add-AppxProvisionedPackage -Online -PackagePath "C:\Windows\Temp\WinGet\$MSIXBundle" -SkipLicense 
    Write-Host "Installation of $PackageName finished"
    
    #Cleanup files
    Start-Sleep 3 # to unblock installation file
    Write-Host "Cleaning up. Deleting this folder: C:\Windows\Temp\WinGet"
    Remove-Item -Path "C:\Windows\Temp\WinGet" -Force -Recurse
    
    #Stop transcript
    Stop-Transcript
    
    if ( $rebootNeeded ){
        [System.Environment]::Exit(3010)
    }

    [System.Environment]::Exit(0)
}catch{
    [System.Environment]::Exit(1)
}