function Add-ArmDependencyOn {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSTypeName('ArmResource')]
        $Resource,
        [Parameter(Mandatory)]
        [PSTypeName('ArmResource')]
        $Dependency
    )

    $DependencyResourceId = $Dependency._ResourceId
    $Resource.dependsOn += "$DependencyResourceId"

}