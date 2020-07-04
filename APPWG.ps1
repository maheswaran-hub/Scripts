#Login:
#Login-AzureRmAccount
#Get-AzureRmSubscription |Out-GridView -PassThru | Select-AzureRmSubscription

#GET Details
#Get-AzureRmApplicationGateway | ? {$_.Name -like "*AGW*"} |Select-Object -Property  Name,OperationalState


#Start/stop:
Get-AzureRmApplicationGateway | ? {$_.Name -like "*AGW-WETS*"} |foreach {start-AzureRmApplicationGateway -ApplicationGateway $_}
Get-AzureRmApplicationGateway | ? {$_.Name -like "*AGW-WEQA*"} |foreach {stop-AzureRmApplicationGateway -ApplicationGateway $_}

