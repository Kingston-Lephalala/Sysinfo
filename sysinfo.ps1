#File must be created New-Item SystemInfo.txt#

#System Information Report

$Report = @{}


#Get C_Name

$Report["Computer Name"] = $env:COMPUTERNAME

#Get OS

$OS = Get-CimInstance Win32_OperatingSystem

$Report["OS"] = "$($OS.Caption) ($($OS.Version))"

#Get CPU Info

$CPU = Get-CimInstance Win32_Processor

$Report["CPU"] = $CPU.Name

#Get RAM Information

$RAM = [math]::Round(($OS.TotalVisibleMemorySize / 1MB),2)
$Report["RAM (GB)"] = "$RAM GB"


#Get Disk Space

$Disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
$DiskInfo = @()
foreach ($Disk in $Disks){
    $DiskInfo += "$($Disk.DeviceID): $([math]::Round(($Disk.Size/1GB),2)) GB
                  (Free: $([math]::Round(($Disk.FreeSpace/1GB),2)) GB)"

}
$Report["Disk Space"] = $DiskInfo -join ","


#Display and Export

$Report | Format-Table -AutoSize
$Report | Out-File -FilePath "$env:USERPROFILE\Documents\SystemInfo.txt"

Write-Host "Info Saved as SystemInfo.txt"
