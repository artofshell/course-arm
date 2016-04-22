<#########################################################

  Author: Trevor Sullivan <trevor@artofshell.com>
  Description: This PowerShell script demonstrates how to deploy a Microsoft
    Azure Resource Manager (ARM) JSON template using Windows PowerShell.

COPYRIGHT NOTICE

This file is part of the "Microsoft Azure Resource Manager (ARM)" training course, and is 
copyrighted by Art of Shell LLC. This file may not be copied or distributed, without 
written permission from an authorized member of Art of Shell LLC (https://artofshell.com).
For more information, please contact info@artofshell.com.
#########################################################>

### Install the AzureRM PowerShell module
Install-Module -Name AzureRM -Scope CurrentUser;

### Inspect Azure Resource Manager (ARM) PowerShell modules
Clear-Host;
Get-Module -ListAvailable -Name AzureRM*;

### Inspect commands in the ARM PowerShell modules
Get-Command -Module AzureRM*;

### Inspect commands in the AzureRM.Profile module
Get-Command -Module AzureRM.Profile;

### Authenticate to Microsoft Azure
$AzureUsername = 'aos@artofshell.com';
$AzureCredential = Get-Credential -Message 'Please enter your Microsoft Azure password.' -UserName $AzureUsername;
Add-AzureRmAccount -Credential $AzureCredential;

#region Subscription Management 

### List available Microsoft Azure subscriptions, after authenticating
Get-AzureRmSubscription;

### Select a subscription to operate on

### Command alias: Select-AzureRmSubscription
Set-AzureRmContext -SubscriptionId 1c9fd9f5-a2dc-4cc9-a73c-cab0ee4a95a1;
Set-AzureRmContext -SubscriptionName 'Visual Studio Ultimate with MSDN';

#endregion

#region Azure Resource Manager (ARM) Resource Providers

Clear-Host;
Get-Command -Name *provider* -Module AzureRM.Resources;

### Get a list of all registered Azure Resource Manager (ARM) Resource Providers
Get-AzureRmResourceProvider;

### Get a list of all Azure Resource Manager (ARM) Resource Providers
Get-AzureRmResourceProvider -ListAvailable;

### Register an Azure Resource Manager (ARM) Resource Provider
Register-AzureRmResourceProvider -ProviderNamespace Microsoft.StreamAnalytics -Force;

### Unregister an Azure Resource Manager (ARM) Resource Provider
Unregister-AzureRmResourceProvider -ProviderNamespace Microsoft.StreamAnalytics -Force;

### Get Resource Provider-specific features
Get-AzureRmProviderFeature;

### Register a Resource Provider-specific feature
Register-AzureRmProviderFeature -ProviderNamespace Microsoft.Automation -FeatureName dsc -Force;
#endregion

#region Azure Resource Manager (ARM) Resource Groups

Get-Command -Module AzureRM* -Name *ResourceGroup*;

$ResourceGroup = @{
    Name = 'artofshell-storage';
    Location = 'North Central US';
    Tag = @(
        @{ Name = 'Department';
           Value = 'Marketing'; }
        );
    Force = $true;
    };
New-AzureRmResourceGroup @ResourceGroup;

### Update the Department tag on the Resource Group
Set-AzureRmResourceGroup -Name $ResourceGroup.Name `
    -Tag @{ Name = 'Department'; Value = 'DevOps'; };

### Search for a Resource Group that matches a tag
Find-AzureRmResourceGroup -Tag @{ Name = 'Department'; Value = 'DevOps'; }

#endregion


#region Manage Azure resource using generic Resource Management interface

Get-Command -Module AzureRM.Resources;

$StorageAccountResource = @{
    ResourceGroupName = $ResourceGroup.Name
    Name = 'contosostorage6';
    Location = 'West Europe';
    ResourceType = 'Microsoft.Storage/storageAccounts';
    ApiVersion = '2015-06-15';
    Properties = @{ 
        accountType = 'Standard_LRS'
        };
    };
New-AzureRmResource @StorageAccountResource;

#endregion

#region Manage Azure resources using resource-specific interfaces

### Benefits:
###   
###  - More PowerShell friendly (parameter names and Intellisense / auto-completion)
###  - Doesn't require you to remember API Version and exact Resource Type
###  - Commands are more easily discoverable, using Get-Command

### Availability Set commands
Get-Command -Name *availabilityset*;

$AvailabilitySet = @{
    ResourceGroupName = $ResourceGroup.Name;
    Location = 'West Europe';
    Name = 'AVSet-ArtofShell-Database';
    };
New-AzureRmAvailabilitySet @AvailabilitySet;

### Virtual Machine commands
Get-Command -Module AzureRM* -Name *vm*;

### Obtain a list of Azure Virtual Machines
Get-AzureRmVm;

### Start an Azure Virtual Machine
Start-AzureRmVm -Name Trevor -ResourceGroupName MYCOOLRESOURCEGROUP;

### Stop an Azure Virtual Machines
Stop-AzureRmVm -Name Trevor -ResourceGroupName MYCOOLRESOURCEGROUP;

#endregion

#region Deploy declarative Microsoft Azure Resource Manager (ARM) JSON Templates

### Search for ARM Resource Group deployment-related commands
Get-Command -Module AzureRM.Resources -Name *deployment;

### Perform a declarative deployment of an Azure Resource Manager (ARM) JSON Template
$Deployment = @{
    ResourceGroupName = $ResourceGroup.Name;
    TemplateUri = 'https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-simple-linux/azuredeploy.json';
    TemplateParameterObject = @{
        adminUsername = 'artofshell';
        adminPassword = 'P@ssw0rd!!';
        dnsLabelPrefix = 'artofshell-arm';
        };
    Mode = 'Complete'; ### Alternative is "incremental"
    Force = $true;
    Name = 'artofshell-armdeploy';
    };
New-AzureRmResourceGroupDeployment @Deployment;

### Obtain the status of the Resource Group Deployment, and input/output parameters
Get-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroup.Name -Name $Deployment.Name;

### View a log of deployments
Get-AzureRmLog -ResourceGroup $ResourceGroup.Name;

#endregion


### FIN