<#########################################################

  Author: Trevor Sullivan <trevor@artofshell.com>
  Description: This PowerShell script demonstrates how to deploy a Microsoft
    Azure Resource Manager (ARM) JSON template using Windows PowerShell.

COPYRIGHT NOTICE

This file is part of the "Microsoft Azure Resource Manager (ARM)" training course, and is 
copyrighted by Art of Shell LLC. This file may not be copied or distributed, without 
written permission from an authorized member of Art of Shell LLC.
#########################################################>

#region Create a new Resource Group
$ResourceGroup = @{
    Name = 'artofshell-linked';
    Location = 'westus';
    Force = $true;
    };

New-AzureRmResourceGroup @ResourceGroup;
#endregion

#region Create a new Resource Group Deployment
$Deployment = @{
    ResourceGroupName = $ResourceGroup.Name;
    Mode = 'Complete';
    TemplateParameterObject = @{
        };
    TemplateFile = '{0}\main-template.json' -f $PSScriptRoot;
    Name = 'LinkedTemplate';
    Force = $true;
    };

New-AzureRmResourceGroupDeployment @Deployment;
#endregion

#region Check on status of deployment
Get-AzureRmResourceGroupDeployment -ResourceGroupName $Deployment.ResourceGroupName -Name $Deployment.Name;
#endregion

#region Delete Resource Group
Remove-AzureRmResourceGroup -Name $ResourceGroup.Name -Force;
#endregion 