Write-host "********************************** Product Management***********************************" -ForegroundColor Green
"`n"
write-host "Hostname:" $env:COMPUTERNAME "|" "Logged in user:" $env:username "|" "Powershell Version:" $PSVersionTable.PSVersion.Major
#$=Login-AzureRmAccount
$GetSub=Get-AzureRmSubscription | Out-GridView -Title "select the subscription" -PassThru
$sub=Select-AzureRmSubscription -SubscriptionId $GetSub.SubscriptionId
$logtime=Get-Date -Format g
$date = Get-Date -format "yyyyMMdd"
"`n"
write-host "==============================================================================================================================="
Write-host "You" $sub.Account "have logged into" $sub.Subscription.SubscriptionName "at" $logtime -ForegroundColor Yellow
write-host "==============================================================================================================================="
#Setting APIM context
$ApiMgmtContexttest= New-AzureRmApiManagementContext -ResourceGroupName test2-emea-platform-api -ServiceName test2-emea-apim
$ApiMgmtContextQA= New-AzureRmApiManagementContext -ResourceGroupName qa2-emea-platform-api -ServiceName qa2-emea-apim -Verbose
$ApiMgmtContextPROD= New-AzureRmApiManagementContext -ResourceGroupName prod2-emea-platform-api -ServiceName prod2-emea-apim -Verbose
#Assiging variables for APIM
$Test=$ApiMgmtContexttest
$QA=$ApiMgmtContextQA
$PROD=$ApiMgmtContextPROD
$APIM= @($Test,$QA,$PROD)| Out-GridView -Title "Select the API Manager" -PassThru
#$environ.count
if($APIM.count -eq 1)
{
function Cproduct
{
$psuffix=Get-Date -format "ddMMyyyy"
$pprefix=""
$Pidd=Read-host "Enter the shortcode (i.e LXP)" -Verbose
$productid= $pprefix + $Pidd + $psuffix
$Title=Read-host "Enter the name the product" -Verbose
$Description=Read-host "Enter the Description of this Product" -Verbose
"`n"
Write-host "You have selected Following Resource Group to Create product" -ForegroundColor Yellow
$APIM
New-AzureRmApiManagementProduct -Context $APIM –ProductId $productid –Title $Title –Description $Description  –LegalTerms 'Strict Terms' –SubscriptionRequired $true –ApprovalRequired $true  –State 'Published' -SubscriptionsLimit 1 -ErrorAction stop -Debug
$group = Get-AzureRmApiManagementGroup -Context $APIM|? {$_.Name -like "Developers"}
Add-AzureRmApiManagementProductToGroup -ProductId $productid  -GroupId $group.GroupId -Context $APIM
"`n"
Write-host "New Product is created successfully and it's ID " $productid -ForegroundColor Yellow
Write-host "Getting the Product list form APIM" -ForegroundColor Yellow
Get-AzureRmApiManagementProduct -Context $APIM|FT Productid,Title,ApprovalRequired,SubscriptionRequired,state
Write-host "Type Y to continue" -BackgroundColor Green
"`n"
$confirmation = Read-Host -Prompt "Do you want to add API's to New Product"
if ($confirmation -eq 'y')
{
  AddAPI
}
else {Write-host "*****It seems you do not want to add API now******" -ForegroundColor Red}
"`n"
sleep -Seconds 2
#Remove-AzureRmApiManagementProduct -Context $ApiM -ProductId vccPaulpaul18012017 -Confirm -DeleteSubscriptions -Verbose
}
function AddAPI
{
#Select the product
Write-host "List of avaialable Product's" -ForegroundColor DarkYellow
$prdlist=Get-AzureRmApiManagementProduct -Context $APIM |Select Productid,Title,ApprovalRequired,SubscriptionRequired,state | Out-GridView -Title "Select the product" -PassThru
$prdlist
#Add API to selected Product
Write-host "Select the API's to Add to" $prdlist.Title -ForegroundColor DarkYellow
$selectApi=Get-AzureRmApiManagementApi -Context $APIM | select APiID,Name,Path |Out-GridView -PassThru
$selectApi
ForEach ($api in $selectApi )
    {
     Write-host "Adding" $api.Name "to" $prdlist.Title -BackgroundColor DarkGreen
      "`n"
     Add-AzureRmApiManagementApiToProduct -ApiId $api.ApiId -Context $APIM -ProductId $prdlist.ProductId -Verbose
    }
"`n"
write-host "Above listed API's are added & Product is associated with following group" -ForegroundColor Yellow
$Prdlist|Get-AzureRmApiManagementGroup -Context $APIM |ft Name,GroupId
}
#Operations to be executed
$ops= @("Create New Product","Add API to Existing Product")| Out-GridView -Title "Select the operations" -PassThru
#$environ.count
if($ops.count -eq 1)
{
###########Create New Product##################
if($ops -eq "Create New Product"){Cproduct}
###########Add API##################
if($ops -eq "Add API to Existing Product"){AddAPI}
}#end of Ops IF block
else {write-host "Wrong input !!" -BackgroundColor Red
       sleep -Seconds 10
       Exit }
}#end of Main IF block
else {write-host "Oops Something went wrong !!!" -BackgroundColor Red
      sleep -Seconds 10
      Exit}
write-host "==============================================================================================================================="
Write-host "Cool ! You are done" "at" $logtime  "#we are working on more optimization#" -ForegroundColor Yellow
write-host "==============================================================================================================================="
sleep -Seconds 5