function Add-ArmDependencyOn {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSTypeName('ArmResource')]
        $Resource,
        [Parameter(Mandatory)]
        [PSTypeName('ArmResource')]
        $Dependency,
        [switch]
        $PassThru = $True
    )

    $DependencyResourceId = $Dependency._ResourceId
    $Resource.dependsOn += "$DependencyResourceId"

    if ($PassThru.ToBool()) {
        return $Resource
    }
}