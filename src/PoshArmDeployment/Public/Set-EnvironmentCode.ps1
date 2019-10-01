function Set-EnvironmentCode {
    [cmdletbinding(SupportsShouldProcess = $True)]
    Param(
        [string]
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $EnvironmentCode
    )

    If ($PSCmdlet.ShouldProcess("Setting the $$script:EnvironmentCode variable")) {
        $script:EnvironmentCode = $EnvironmentCode
    }
}