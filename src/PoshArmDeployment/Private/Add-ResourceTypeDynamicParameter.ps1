#Requires -Version 5.0

function Add-ResourceTypeDynamicParameter {
    [CmdletBinding()]
    Param(
        [Parameter()]
        [System.Management.Automation.RuntimeDefinedParameterDictionary]
        $RuntimeDefinedParameterDictionary = (New-Object System.Management.Automation.RuntimeDefinedParameterDictionary)
    )
    $ErrorActionPreference = 'Stop'
    $ParameterName = 'ResourceType'

    $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
    $ParamAttribute = New-Object System.Management.Automation.ParameterAttribute
    $ParamAttribute.Mandatory = $false
    $ParamAttribute.Position = 0
    $AttributeCollection.Add($ParamAttribute)

    $arrSet = Get-SupportedResourceProviders | Select-Object -ExpandProperty resourceType

    $ValidateSetParamAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
    $ValidateSetParamAttribute.IgnoreCase = $true

    if ($ValidateSetParamAttribute.ValidValues.Count -eq 0) {
        Write-Error 'Unable to extract supported resource providers'
    }

    $AttributeCollection.Add($ValidateSetParamAttribute)

    $RunTimeParam = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)

    $RuntimeDefinedParameterDictionary.Add($ParameterName, $RunTimeParam)

    $RuntimeDefinedParameterDictionary
}