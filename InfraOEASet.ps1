
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
$config = New-AzSynapseGitRepositoryConfig -RepositoryType GitHub -AccountName Sarang-CommunityBrands -RepositoryName OEA -CollaborationBranch main
Update-AzSynapseWorkspace -ResourceGroupName $resource_group -Name $synapseName -GitRepository $config

}

# function call
#az login
Set-OEA 79a9a1b8-17c9-4098-bbae-16c21b7edd2a cbuk-oea-dev-rg cbuk-oea-dev-kv cbuk-oea-dev-syn
