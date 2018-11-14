function New-ArmTemplate {
    [cmdletbinding(SupportsShouldProcess = $True)]
    Param(
        $schema = "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
        [switch]
        $Passthru
    )

    If ($PSCmdlet.ShouldProcess("Creating new ArmTempate and affecting $$script:ArmTemplate variable")) {
        $templateObject = [pscustomobject][ordered]@{
            '$schema'      = $schema
            contentVersion = "1.0.0.0"
            parameters     = [pscustomobject]@{}
            variables      = [pscustomobject]@{}
            resources      = @()
            outputs        = [pscustomobject]@{}
        }

        if ($script:ArmTemplate) {
            $script:ArmTemplate = $templateObject
        }

        if ($Passthru.IsPresent) {
            $templateObject
        }
    }
}