function Set-ArmResourceNamingConvention {
    [cmdletbinding(SupportsShouldProcess = $True)]
    Param(
        [string]
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $NamingConvention
    )

    If ($PSCmdlet.ShouldProcess("Setting the $$script:ResourceNamingConvention variable")) {
        $script:ResourceNamingConvention = $NamingConvention
    }
}