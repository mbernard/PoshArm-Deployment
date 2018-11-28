function Remove-ExtraBracketInArmTemplateFunction {
    [cmdletbinding(SupportsShouldProcess = $true)]
    [OutputType([PSCustomObject])]
    Param(
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
    If ($PSCmdlet.ShouldProcess("Removing all extra '[]' in property value that are nested Arm template function")) {
        if (!$InputObject) {
            return $InputObject
        }
        if ($InputObject -is [string]) {
            if (($InputObject.ToCharArray() | Where-Object {$_ -eq '['} | Measure-Object).Count -gt 1) {
                # Keep the first '[' and the last ']'
                $i = $InputObject.IndexOf('[')
                $InputObject = $InputObject.Replace('[', '')
                $InputObject = $InputObject.Insert($i, '[')

                $li = $InputObject.LastIndexOf(']')
                $InputObject = $InputObject.Replace(']', '')
                if ($li -gt $InputObject.Length) {
                    $InputObject = $InputObject + ']'
                }
                else {
                    $InputObject = $InputObject.Insert($li, ']')
                }

                return $InputObject
            }
            else {
                return $InputObject
            }
        }
        else {
            $properties = [PSCustomObject]$InputObject | Get-Member -MemberType *Property
            foreach ($property in $properties) {
                $propertyName = $property.Name
                $propertyValue = $InputObject.$propertyName

                if ($propertyValue -is [array]) {
                    $InputObject.$propertyName = @($propertyValue | ForEach-Object { $_ | Remove-ExtraBracketInArmTemplateFunction })
                }
                else {
                    # Recurse
                    $InputObject.$propertyName = $InputObject.$propertyName | Remove-ExtraBracketInArmTemplateFunction
                }
            }

            return $InputObject
        }
    }
}