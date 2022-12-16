
Function Azure-CLI-Installed()
{
    # Check Microsoft Azure CLI is installed or not.
    return (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
    Where { $_.DisplayName -eq 'Microsoft Azure CLI' }) -ne $null
}

Write-Host -message 'Please login with admin account'
Function Set-AzModule(){
    $isAzureCliInstalled = Azure-CLI-Installed
    if (!$isAzureCliInstalled) {
        Write-Host 'Trying to install Microsoft Azure CLI'
        Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList ‘/I AzureCLI.msi /quiet’; rm .\AzureCLI.msi
        $isAzureCliInstalled = Azure-CLI-Installed;
    
        if (!$isAzureCliInstalled) {
            Write-Host -message 'Unable to install Microsoft Azure CLI'
        }
        else {
            Write-Host -message 'Microsoft Azure CLI installed successfully'
            az login
            ## Here the command is failing power shell not able to find the az module
        }
    }
	else
	{
	 az login
	}
}

Set-ExecutionPolicy RemoteSigned
Install-Module Az.Resources
Install-Module -Name Az.Accounts -RequiredVersion 2.10.4
Install-Module -Name Az.KeyVault -RequiredVersion 2.0.0
Install-Module -Name Az.ManagedServiceIdentity
Install-Module -Name Az.Synapse

Import-Module Az.Resources
Import-Module -Name Az.KeyVault
Import-Module -Name Az.ManagedServiceIdentity
Import-Module -Name Az.Accounts -RequiredVersion 2.10.4
Import-Module -Name Az.Synapse
# function call
Set-AzModule
$subscription_id = Read-Host -Prompt "Please enter subscription id"
az account set --subscription $subscription_id
Write-Host "Subscription $subscription_id is set"

$resource_group = Read-Host -Prompt "Please enter resource group name in set subscription"

$resourceGroup = Get-AzResourceGroup -Name $resource_group

Write-Host "Resource group $resource_group is set, and key vault will be created in same resource group"

# key vault will be already there
$keyVaultName = Read-Host -Prompt "Please enter key vault name"
# Create a key vault
#$keyVault = New-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location


#Connect-AzAccount
#Set-AzContext -SubscriptionId $subscription_id
#$context = Get-AzContext
#$user = $context.Account
#Set-AzKeyVaultAccessPolicy -VaultName $keyVaultName -UserPrincipalName $user.Id -PermissionsToSecrets get,set
#Write-Host 'current user -'$user

$xporterRelyingPartySecretValue = "one.assembly.education"
$xrpsecureString = ConvertTo-SecureString $xporterRelyingPartySecretValue -AsPlainText -Force
$secretRelyingPartyName = "XporterRelyingParty"
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $secretRelyingPartyName -SecretValue $xrpsecureString


$xporterRelyingPartySecretSecretValue = "EFC642410CED454FB3DC78D8339EE135"

$secretRelyingPartySecretName = "XporterRelyingPartySecret"

Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $secretRelyingPartySecretName -SecretValue $xporterRelyingPartySecretSecretValue


#setting the github account
$config = New-AzSynapseGitRepositoryConfig -RepositoryType GitHub -AccountName Sarang-CommunityBrands -RepositoryName OEA -CollaborationBranch dev-main
$password = ConvertTo-SecureString "Communitybrands@123" -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ("Sarang.Kulkarni@communitybrands.com", $password)
Update-AzSynapseWorkspace -ResourceGroupName cbuk-oea-dev-rg -Name cbuk-oea-dev-syn -GitRepository $config

















