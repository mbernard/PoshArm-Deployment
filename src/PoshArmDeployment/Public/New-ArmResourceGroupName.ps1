function New-ArmResourceGroupName {
    [CmdletBinding()]
    param(
        [string]
        $ProjectName = $script:projectName,
        [string]
        $EnvironmentCode = $script:environmentCode,
        [string]
        $Context = $script:context,
        [string]
        $Location = $script:location
    )

    $ResourceGroupNameParts = @(
        $ProjectName
        $EnvironmentCode
        $Context
        $Location
    ) | Where-Object {$_}
    $ResourceGroupName = [string]::Join('-', $ResourceGroupNameParts)
    $ResourceGroupName = $ResourceGroupName.ToLowerInvariant()

    return $ResourceGroupName
}