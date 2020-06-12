function Add-ArmDependencyOn {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSTypeName('ArmResource')]
        $Resource,
        [Parameter(Mandatory)]
        $Dependency,
        [switch]
        $PassThru
    )

    $DependencyResourceId = $Dependency._ResourceId
    $Resource.dependsOn += "$DependencyResourceId"

    if ($PassThru.IsPresent) {
        return $Resource
    }
}