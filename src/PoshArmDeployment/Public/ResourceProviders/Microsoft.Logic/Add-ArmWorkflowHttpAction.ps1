function Add-ArmWorkflowHttpAction {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("WorkflowDefinition")]
    Param(
        [PSTypeName("WorkflowDefinition")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $WorkflowDefinition,
        [Parameter(Mandatory)]
        [ValidateSet('GET', 'PUT', 'POST', 'PATCH', 'DELETE', 'HEAD', 'OPTIONS', 'CONNECT', 'TRACE')]
        $Method,
        [Parameter(Mandatory)]
        [string]
        $Uri,
        [PSCustomObject]
        $Body
    )

    If ($PSCmdlet.ShouldProcess("Adding Http Action to Workflow Definition")) {
        $HttpAction = @{
            runAfter = @{}
            type     = "Http"
            inputs   = @{
                body    = $Body
                method  = $Method
                headers = @{}
                uri     = $Uri
            }
        }

        $WorkflowDefinition.actions.HTTP = $HttpAction

        return $WorkflowDefinition
    }
}