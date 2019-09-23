[![Build status](https://sybersphere.visualstudio.com/PoshArmDeployment/_apis/build/status/PoshArmDeployment-CI)](https://sybersphere.visualstudio.com/PoshArmDeployment/_build/latest?definitionId=5)

PoshArm-Deployment is a perfect hybrid between ARM Templates and Azure PowerShell. It leverage those 2 technologies to deliver a powerful development experience.

| |PoshArm-Deployment|ArmTemplate|Azure PowerShell|
|---|---|---|---|
|Powerful settings management|✔️|❌|❌|
|Deterministic unique names generator that supports versioning|✔️|❌|❌|
|Conventions over configuration|✔️|❌|❌|
|DSC (Desired State Configuration|✔️|✔️|❌|
|Conditional\Complex logic|✔️|❌|✔️|
|Integration with existing PowerShell scripts|✔️|❌|✔️|


# Examples
```PowerShell
$Output = Publish-ArmResourceGroup -EnvironmentCode $EnvironmentCode -ArmResourcesScriptBlock `
    {
        Param($config)

        # Storage Account
        New-ArmResourceName Microsoft.Storage/storageAccounts `
        | New-ArmStorageResource `
        | Add-ArmResource
        
        etc...
    }
```

### Configuration file
`ScriptConfiguration.json`
```json
{
  "projectName": "project",
  "location": "eastus2",
  "environmentCode": "",
  "context": "context",
  "version": "1.0",
  "properties": {
    }
  }
}
```

`ScriptConfiguration.local.json`
```json
{
  "environmentCode": "local",
  "properties": {}
}
```

Generates
```json
{
  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    
  },
  "variables": {
    
  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "name": "[concat('sa0', uniqueString('project','local','context','eastus2','sa','sa','1.0'))]",
      "apiVersion": "2018-07-01",
      "location": "eastus2",
      "sku": {
        "name": "Standard_LRS",
        "tier": "Standard"
      },
      "kind": "StorageV2",
      "properties": {
        "supportsHttpsTrafficOnly": true,
        "accessTier": "Hot",
        "encryption": {
          "services": {
            "blob": {
              "enabled": true
            },
            "file": {
              "enabled": true
            }
          },
          "keySource": "Microsoft.Storage"
        }
      },
      "resources": [
        
      ],
      "dependsOn": [
        
      ]
    }
  ],
  "outputs": {
  }
}

```
