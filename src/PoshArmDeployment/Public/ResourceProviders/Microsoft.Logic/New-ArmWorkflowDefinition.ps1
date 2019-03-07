function New-ArmWorkflowDefinition {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("WorkflowDefinition")]
    Param(
        [string]
        $ContentVersion = '1.0.0.0',
        [switch]
        $WithouHttpTrigger,
        [PSCustomObject]
        $HttpTriggerSchema = @{}
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Workflow Definition")) {
        $Triggers = @{}

        If ($WithouHttpTrigger.ToBool() -ne $True) {
            $HttpTrigger = @{
                type   = 'Request'
                kind   = 'Http'
                inputs = @{
                    schema = $HttpTriggerSchema
                }
            }
            $Triggers.manual = $HttpTrigger
        }

        $WorkflowDefinition = [PSCustomObject][ordered]@{
            '$schema'      = 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
            PSTypeName     = 'WorkflowDefinition'
            contentVersion = $ContentVersion
            parameters     = @{}
            triggers       = $Triggers
            actions        = @{}
            outputs        = @{}
        }

        return $WorkflowDefinition
    }
}