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
        $Location = $script:location,
        [string]
        $Delimiter = "-",
        [string]
        $NamingConvention = $script:resourceGroupNamingConvention
    )

    if (!$NamingConvention) {
        $NamingConvention = "{projectname}{delimiter}{environmentcode}{delimiter}{context}{delimiter}{location}"
    }

    $ResourceGroupName = $NamingConvention.ToLowerInvariant()
    $ResourceGroupName = $ResourceGroupName.Replace("{delimiter}", $Delimiter)
    $ResourceGroupName = $ResourceGroupName.Replace("{projectname}", $ProjectName)
    $ResourceGroupName = $ResourceGroupName.Replace("{environmentcode}", $EnvironmentCode)
    $ResourceGroupName = $ResourceGroupName.Replace("{context}", $Context)
    $ResourceGroupName = $ResourceGroupName.Replace("{location}", $Location)

    return $ResourceGroupName.ToLowerInvariant()
}