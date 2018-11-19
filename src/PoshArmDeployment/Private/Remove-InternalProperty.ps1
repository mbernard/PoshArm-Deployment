function Remove-InternalProperty {
    [cmdletbinding(SupportsShouldProcess = $True)]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSCustomObject]
        $InputObject
    )

    If ($PSCmdlet.ShouldProcess("Removing all properties starting with an underscore on target object")) {
        $propertyNames = $([PSCustomObject]$inputObject | Get-Member -MemberType *Property).Name
        foreach ($propertyName in $propertyNames) {
            $propertyValue = $InputObject.$propertyName

            if ($propertyName.StartsWith("_")) {
                $InputObject.PSObject.Properties.Remove($propertyName)
            }
            elseif($propertyValue -is [array]){
                $InputObject.$propertyName = @($propertyValue | ForEach-Object { [PSCustomObject]$_ | Remove-InternalProperty })
            }
            elseif ($propertyValue -is [PSCustomObject] -Or $propertyValue -is [hashtable] ) {
                # Recurse
                $InputObject.$propertyName = [PSCustomObject]$propertyValue | Remove-InternalProperty
            }
        }

        return $InputObject
    }
}