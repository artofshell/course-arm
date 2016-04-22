<#########################################################

  Author: Trevor Sullivan <trevor@artofshell.com>
  Description: This PowerShell script demonstrates how to create a custom Azure
    Resource Manager (ARM) Policy, apply it to a Resource Group, and demonstrate
    how the policy prevents unauthorized actions from occurring.

COPYRIGHT NOTICE

This file is part of the "Microsoft Azure Resource Manager (ARM)" training course, and is 
copyrighted by Art of Shell LLC. This file may not be copied or distributed, without 
written permission from an authorized member of Art of Shell LLC (https://artofshell.com).
For more information, please contact info@artofshell.com.
#########################################################>

#region Authenticate to Microsoft Azure
$AzureUsername = 'aos@artofshell.com';
$AzureCredential = Get-Credential -Message 'Please enter your Microsoft Azure password.' -UserName $AzureUsername;
Add-AzureRmAccount -Credential $AzureCredential;
#endregion

### Set up subscription ID and Resource Group Name as variables, so we can easily reuse them.
$SubscriptionId = '1c9fd9f5-a2dc-4cc9-a73c-cab0ee4a95a1';
$ResourceGroupName = 'ArtofShell-RBAC';

### Create the Azure Resource Manager (ARM) Resource Group
New-AzureRmResourceGroup -Name $ResourceGroupName -Location 'North Central US' -Force;

### Prompt for an Azure ACtive Directory (AAD) security group to grant access to
$AADGroup = Get-AzureRmADGroup | Out-GridView -OutputMode Single -Title 'Please select an Azure Active Directory (AAD) Group.';

### Prompt to select a role definition to assign the AAD group to
$RoleDefinition = Get-AzureRmRoleDefinition | Out-GridView -OutputMode Single -Title 'Please select an ARM Role Definition.';

### Create a new ARM Role Assignment
$RoleAssignment = @{
    ObjectId = $AADGroup.Id;
    ResourceGroupName = $ResourceGroupName;
    RoleDefinitionName = $RoleDefinition.Name;
    };
New-AzureRmRoleAssignment @RoleAssignment;

### Remove the Azure Resource Manager (ARM) Resource Group
Remove-AzureRmResourceGroup -Name $ResourceGroupName -Force