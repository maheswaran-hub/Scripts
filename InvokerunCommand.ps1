﻿$remoteCommand = {Gpupdate /force}
# Save the command to a local file
Set-Content -Path "" -value $remoteCommand
Get-Content -Path ""

Connect-AzAccount
Get-AzSubscription |Out-GridView -PassThru | Select-AzSubscription
#$rg = Get-AzResourceGroup -Name --------
#$vm = Get-AzVM | ? {$_.Name -like "*------*"}
Invoke-AzVMRunCommand -VMName VM--PIMDC1  -ResourceGroupName RG--OPS -CommandId "RunPowerShellScript" -ScriptPath "\script.ps1"


