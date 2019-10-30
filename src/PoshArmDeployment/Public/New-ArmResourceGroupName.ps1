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

    # make sure we don't have 2 delimiter with nothing between them
    while ($ResourceGroupName.Contains("$Delimiter$Delimiter")){
        $ResourceGroupName = $ResourceGroupName.Replace("$Delimiter$Delimiter", $Delimiter)
    }

    return $ResourceGroupName.ToLowerInvariant()
}