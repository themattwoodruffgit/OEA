# function call

function Set-OEA {
    [cmdletbinding()]
    param(
        [string]$subscriptionId,
        [string]$resourceGroup,
		 [string]$keyvaultname,
		  [string]$synapsename
		
    )

	
#set parameters
$subscription_id = $subscriptionId
$resource_group = $resourceGroup
$keyVaultName = $keyvaultname
$synapseName = $synapsename

#execution
az account set --subscription $subscription_id



$resourceGroup = Get-AzResourceGroup -Name $resource_group


$xporterRelyingPartySecretValue = "one.assembly.education"
$xrpsecureString = ConvertTo-SecureString $xporterRelyingPartySecretValue -AsPlainText -Force
$secretRelyingPartyName = "XporterRelyingParty"
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $secretRelyingPartyName -SecretValue $xrpsecureString


$xporterRelyingPartySecretSecretValue = "EFC642410CED454FB3DC78D8339EE135"
$xrpssecureString = ConvertTo-SecureString $xporterRelyingPartySecretSecretValue -AsPlainText -Force
$secretRelyingPartySecretName = "XporterRelyingPartySecret"

Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $secretRelyingPartySecretName -SecretValue $xrpssecureString


#setting the github account
$config = New-AzSynapseGitRepositoryConfig -RepositoryType GitHub -AccountName Sarang-CommunityBrands -RepositoryName OEA -CollaborationBranch dev-main
$password = ConvertTo-SecureString "Communitybrands@123" -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ("Sarang.Kulkarni@communitybrands.com", $password)
Update-AzSynapseWorkspace -ResourceGroupName cbuk-oea-dev-rg -Name $synapseName -GitRepository $config

}
