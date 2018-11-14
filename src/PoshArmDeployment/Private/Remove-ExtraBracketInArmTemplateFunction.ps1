function Remove-ExtraBracketInArmTemplateFunction {
    [cmdletbinding(SupportsShouldProcess = $true)]
    [OutputType([PSCustomObject])]
    Param(
        [Parameter(ValueFromPipeline)]
        [PSCustomObject]
        $InputObject
    )
    If ($PSCmdlet.ShouldProcess("Removing all extra '[]' in property value that are nested Arm template function")) {
        $properties = $InputObject | Get-Member -MemberType *Property
        foreach ($property in $properties) {
            $propertyName = $property.Name
            $propertyValue = $InputObject.$propertyName
            $propertyType = $InputObject.$propertyName.GetType().Name
            if ($propertyType -eq "PSCustomObject") {
                # Recurse
                $InputObject.$propertyName = $InputObject.$propertyName | Remove-ExtraBracketInArmTemplateFunction
            } elseif ($propertyType -eq "String" -And
                ($propertyValue.ToCharArray() | Where-Object {$_ -eq '['} | Measure-Object).Count -gt 1) {
                # Keep the first '[' and the last ']'
                $i = $propertyValue.IndexOf('[')
                $propertyValue = $propertyValue.Replace('[', '')
                $propertyValue = $propertyValue.Insert($i, '[')

                $li = $propertyValue.LastIndexOf(']')
                $propertyValue = $propertyValue.Replace(']', '')
                if($li -gt $propertyValue.Length)
                {
                    $propertyValue = $propertyValue + ']'
                } else {
                    $propertyValue = $propertyValue.Insert($li, ']')
                }

                $InputObject.$propertyName = $propertyValue
            }
        }

        return $InputObject
    }
}