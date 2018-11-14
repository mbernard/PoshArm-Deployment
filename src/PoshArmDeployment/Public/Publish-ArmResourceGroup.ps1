function Publish-ArmResourceGroup {
    [CmdletBinding()]
    param(
        [ValidatePattern('^[a-z0-9-]*$')]
        [string]
        $EnvironmentCode = "dev",
        [parameter(Position = 0, Mandatory = $true)]
        [ScriptBlock]
        $ArmResourcesScriptBlock,
        [hashtable]
        $ArmTemplateParams = @{},
        [string]
        $ResourceGroupName,
        [switch]
        $Test,
        [string]
        $ConfigurationPath = $MyInvocation.PSScriptRoot
    )

    Process {
        $Configuration = Initialize-Configuration -Environment $EnvironmentCode -ConfigurationPath $ConfigurationPath

        # 1. Generate ARM Template
        New-ArmTemplate
        Invoke-Command $ArmResourcesScriptBlock -ArgumentList $Configuration

        # 2. Create/Update deployment template file
        if (!$ResourceGroupName) {
            $resourceGroupNameParts = @(
                $script:ProjectName
                $script:EnvironmentCode
                $script:Context
                $script:Location
            ) | Where-Object {$_}
            $resourceGroupName = [string]::Join('-', $resourceGroupNameParts)
            $resourceGroupName = $resourceGroupName.ToLowerInvariant()
        }

        $templateFilePath = Join-Path $ConfigPath "$resourceGroupName-ArmTemplate.GENERATED.json"
        $script:ArmTemplate | Remove-InternalProperty | Out-File -FilePath $TemplateFilePath

        $null = New-AzureRmResourceGroup -Name $resourceGroupName -Location $script:Location -Force

        # 3. Deploy or test to resource group with template file
        if ($Test) {
            $deployment = [PSCustomObject]@{
                ResourceGroupName       = $resourceGroupName
                TemplateFile            = $templateFilePath
                TemplateParameterObject = $ArmTemplateParams
                Verbose                 = $true
            } `
                | ConvertTo-Hash

            (Test-AzureRmResourceGroupDeployment @deployment).Details
        }
        else {
            # 3. Ensure resource group exist
            $date = (Get-Date -Format "s").Replace(":", "-")
            $deploymentName = "$resourceGroupName-deployment-$date"
            $deployment = @{
                Name                    = $deploymentName
                ResourceGroupName       = $resourceGroupName
                TemplateFile            = $templateFilePath
                TemplateParameterObject = $ArmTemplateParams
                Verbose                 = $true
                DeploymentDebugLogLevel = $(if ($PSCmdlet.MyInvocation.BoundParameters["Debug"]) {'All'} else {'None'})
            } `
                | ConvertTo-Hash

            $deploymentResult = New-AzureRmResourceGroupDeployment @deployment
            $deploymentResult

            if ($deploymentResult -and $PSCmdlet.MyInvocation.BoundParameters["Debug"]) {
                Write-Debug 'Fetching deployment operations...'
                $operations = Get-AzureRmResourceGroupDeploymentOperation `
                    -ResourceGroupName $resourceGroupName `
                    -DeploymentName $deploymentName

                Write-Debug 'Formatted operations:'
                if ($operations) {
                    Format-AzureRmDeploymentOperation -Operations $operations
                }

                Write-Warning "Please STRONGLY consider manually deleting deployment '$deploymentName' to avoid sensitive information leaks."
            }
        }
    }
}