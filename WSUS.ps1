#Login:
#Login-AzureRmAccount
#Get-AzureRmSubscription |Out-GridView -PassThru | Select-AzureRmSubscription

$AU = Get-ChildItem -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate
$Get = (Get-ItemProperty "HKLM:\Software\policies\microsoft\windows\windowsupdate")
$Get.WUstatusServer
$Get.WUServer
$QA = Get-AzureRmVM | ? {$_.Name -like "*QA*"} |Select-Object -Property Name
$Update = {Set-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name WUServer -Value 
Set-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name WUStatusServer -Value 
Set-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name UpdateServiceUrlAlternate -Value 
Set-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name TargetGroup -Value 
Set-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU -Name "NoAutoUpdate" -Value 0
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name ScheduledInstallDay -Value 0
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name ScheduledInstallTime -Value 5
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU -Name "UseWUServer" -Value 1 -PropertyType "DWord"}
Get-AzureRmVM | ? {$_.Name -like "*QA*"} |Select-Object -Property Name | Foreach {$Update}
Write-Host "The registry settings has been configured successfully for the server $env:computername " -ForegroundColor red -BackgroundColor white
Write-Output $AU $Get 
