function ConvertTo-ValueInTemplateExpression {
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $Value
    )

    if(!$Value.StartsWith("[")){
        $Value = "'$Value'"
    }

    return $Value
}