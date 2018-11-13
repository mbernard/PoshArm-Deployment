[CmdletBinding]
function Invoke-ArmResourceGroupDeployment {
    param(
        [ValidatePattern('^[a-z0-9-]*$')]
        [string]
        $EnvironmentCode = "dev",
        [ScriptBlock]
        $CreateArmResourcesScriptBlock,
        [hashtable]
        $ArmTemplateParams = @{},
        [string]
        $ResourceGroupName,
        [switch]
        $TestMode,
        [switch]
        $DebugDeployment,
        [string]
        $ConfigPath
    )

    Process {
        if($DebugDeployment) {
            Write-Host ('Loaded Configuration: {0}' -f ($script:EnvConfig | ConvertTo-Json -Depth 100))
        }
        # TODO Validate mandatory values with schema?

        # 1. Generate ARM Template
        New-ArmTemplate
        Invoke-Command $CreateArmResourcesScriptBlock -ArgumentList $script:EnvConfig

        # 2. Create/Update deployment template file
        if (!$ResourceGroupName) {
            $resourceGroupNameParts = @(
                $script:ProjectName
                $script:EnvironmentCode
                $script:Context
                $script:Location
            ) | where {$_}
            $resourceGroupName = [string]::Join('-', $resourceGroupNameParts)
            $resourceGroupName = $resourceGroupName.ToLowerInvariant()
        }

        $templateFilePath = Join-Path $ConfigPath "$resourceGroupName-ArmTemplate.GENERATED.json"
        $jsonTemplate = $script:ArmTemplate | Remove-InternalProperty | Out-File -FilePath $TemplateFilePath

        $null = New-AzureRmResourceGroup -Name $resourceGroupName -Location $script:Location -Force

        # 3. Deploy or test to resource group with template file
        if ($TestMode) {
            $deployment = [PSCustomObject]@{
                ResourceGroupName = $resourceGroupName
                TemplateFile      = $templateFilePath
                TemplateParameterObject = $ArmTemplateParams
                Verbose           = $true
            } `
                | ConvertTo-Hash

            (Test-AzureRmResourceGroupDeployment @deployment).Details
        }
        else {
            # 3. Ensure resource group exist
            $date = (Get-Date -Format "s").Replace(":","-")
            $deploymentName = "$resourceGroupName-deployment-$date"
            $deployment = @{
                Name              = $deploymentName
                ResourceGroupName = $resourceGroupName
                TemplateFile      = $templateFilePath
                TemplateParameterObject = $ArmTemplateParams
                Verbose           = $true
                DeploymentDebugLogLevel = $(if($DebugDeployment){'All'} else {'None'})
            } `
                | ConvertTo-Hash

            $deploymentResult = New-AzureRmResourceGroupDeployment @deployment
            $deploymentResult

            if($deploymentResult -and $DebugDeployment) {
                Write-Host 'Fetching deployment operations...'
                $operations = Get-AzureRmResourceGroupDeploymentOperation `
                    -ResourceGroupName $resourceGroupName `
                    -DeploymentName $deploymentName

                Write-Host 'Formatted operations:'
                if($operations) {
                    Format-AzureRmDeploymentOperation -Operations $operations
                }

                Write-Warning "Please STRONGLY consider manually deleting deployment '$deploymentName' to avoid sensitive information leaks."
            }
        }
    }
}