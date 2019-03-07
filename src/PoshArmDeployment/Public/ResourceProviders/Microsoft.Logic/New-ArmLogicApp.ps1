function New-ArmLogicApp {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("LogicApp")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [PSTypeName("WorkflowDefinition")]
        $WorkflowDefinition = @{},
        [string]
        $ApiVersion = '2017-07-01',
        [string]
        $Location = $script:Location,
        [string]
        $State = 'Enabled'
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Logic App")) {
        $logicApp = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType 'Microsoft.Logic/workflows'
            PSTypeName  = "LogicApp"
            type        = 'Microsoft.Logic/workflows'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = $Location
            tags        = @{}
            properties  = @{
                state      = $State
                parameters = @{}
                definition = $WorkflowDefinition
            }
            dependsOn   = @()
        }

        $logicApp.PSTypeNames.Add("ArmResource")

        return $logicApp
    }
}