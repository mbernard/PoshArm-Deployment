function New-ArmResourceGroupName {
    [CmdletBinding()]
    param(
        [string]
<<<<<<< HEAD
        $ProjectName = $script:projectName,
        [string]
        $EnvironmentCode = $script:environmentCode,
        [string]
        $Context = $script:context,
        [string]
        $Location = $script:location
=======
        $ProjectName = $script.projectName,
        [string]
        $EnvironmentCode = $script.environmentCode,
        [string]
        $Context = $script.context,
        [string]
        $Location = $script.location
>>>>>>> upstream/develop
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