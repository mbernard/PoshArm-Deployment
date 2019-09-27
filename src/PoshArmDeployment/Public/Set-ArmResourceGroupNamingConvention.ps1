function Set-ArmResourceGroupNamingConvention {
    [cmdletbinding(SupportsShouldProcess = $True)]
    Param(
        [string]
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $NamingConvention
    )

    If ($PSCmdlet.ShouldProcess("Setting the $$script:ResourceGroupNamingConvention variable")) {
        $script:ResourceGroupNamingConvention = $NamingConvention
    }
}