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
$ResourceGroupName = 'ArtofShell-Policy';

### Create a new Azure Resource Manager (ARM) Resource Group
New-AzureRmResourceGroup -Name $ResourceGroupName -Location 'West Europe' -Force;

#region Create a new ARM Policy Definition
$AzurePolicy = @{
    Name = 'StorageAccountOnly';
    DisplayName = 'StorageAccountOnly';
    Description = 'Allows only operations on Storage Accounts.'
    Policy = @'
{
  "if" : {
    "not" : {
      "anyOf" : [
        {
          "field" : "type",
          "like" : "Microsoft.Storage/storageAccounts*"
        }
      ]
    }
  },
  "then" : {
    "effect" : "deny"
  }
}
'@;
    };
$AzurePolicy = New-AzureRmPolicyDefinition @AzurePolicy;
#endregion

#region Assign the policy to a Resource Group
$Assignment = @{
    Name = 'Policy';
    Scope = '/subscriptions/{0}/resourceGroups/{1}' -f $SubscriptionId, $ResourceGroupName;
    PolicyDefinition = $AzurePolicy;
    };
New-AzureRmPolicyAssignment @Assignment;
#endregion

#region Attempt to create a non-storage resource
New-AzureRmAvailabilitySet -ResourceGroupName $ResourceGroupName -Name test -Location westus;

### NOTE: We receive an error, because there's a policy in place that prevents the action from occurring.

### Remove the policy and try again
Remove-AzureRmPolicyAssignment -Name $Assignment.Name -Scope $Assignment.Scope -Force;
Remove-AzureRmPolicyDefinition -Name $AzurePolicy.Name -Force;

$Command.Invoke();

Remove-AzureRmAvailabilitySet -ResourceGroupName $ResourceGroupName -Name test -Force;


#endregion
