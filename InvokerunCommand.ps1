$remoteCommand = {Gpupdate /force}
# Save the command to a local file
Set-Content -Path "" -value $remoteCommand
Get-Content -Path ""

Connect-AzAccount
Get-AzSubscription |Out-GridView -PassThru | Select-AzSubscription
#$rg = Get-AzResourceGroup -Name RG-WEPRPIM-OPS
#$vm = Get-AzVM | ? {$_.Name -like "*VM-WEPR-PIMDC*"}
Invoke-AzVMRunCommand -VMName VM-WEPR-PIMDC1  -ResourceGroupName RG-WEPRPIM-OPS -CommandId "RunPowerShellScript" -ScriptPath "C:\Users\maheswaran.pa\Desktop\SOPs\New folder\script.ps1"


