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
$ResourceGroupName = 'ArtofShell-Lock';

### Create an Azure Resource Manager (ARM) Resource Group
New-AzureRmResourceGroup -Name $ResourceGroupName -Location 'Japan West' -Force;

### Create a Resource Lock on the Resource Group
$ResourceLock = @{
    LockName = 'ArtofShellLock';
    LockLevel = 'CanNotDelete';
    LockNotes = 'We don''t want our production cloud resources to be deleted.';
    ResourceGroupName = $ResourceGroupName;
    Force = $true;
    };
New-AzureRmResourceLock @ResourceLock;


### Attempt to remove the Resource Group
Remove-AzureRmResourceGroup -Name $ResourceGroupName -Force;

### Remove the Resource Group Lock
Remove-AzureRmResourceLock -LockName $ResourceLock.LockName -ResourceGroupName $ResourceGroupName -Force