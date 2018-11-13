function Remove-InternalProperty {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSCustomObject]
        $InputObject
    )

    $propNames = $($inputObject | Get-Member -MemberType *Property).Name
    foreach ($propName in $propNames) {
        if($propName.StartsWith("_")){
            $InputObject.PSObject.Properties.Remove($propName)
        }
        elseif ($InputObject.$propName.GetType().Name -eq "PSCustomObject") {
            # Recurse
            $InputObject.$propName = Remove-InternalProperty -InputObject $InputObject.$propName
        }
    }

    return $InputObject
}