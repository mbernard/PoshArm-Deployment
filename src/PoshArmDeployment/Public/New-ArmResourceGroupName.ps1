function New-ArmResourceGroupName {
    param(
        [Parameter(Mandatory)]
        [string]
        $Context
    )

    $ResourceGroupNameParts = @(
        $script.projectName
        $script.environmentCode
        $Context
        $script.location
    ) | Where-Object {$_}
    $ResourceGroupName = [string]::Join('-', $ResourceGroupNameParts)
    $ResourceGroupName = $ResourceGroupName.ToLowerInvariant()

    return $ResourceGroupName
}