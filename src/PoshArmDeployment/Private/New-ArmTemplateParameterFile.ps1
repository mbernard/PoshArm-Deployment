function New-ArmTemplateParameterFile {
    [CmdletBinding()]
    param(
        [string]
        [Parameter(Mandatory)]
        $TemplateParameterFilePath,
        $ArmTemplateParams
    )

    $script:ArmParameters = $script:ArmParameters | Merge-Object $ArmTemplateParams | ConvertTo-Hash
    $ArmParameters = [pscustomobject][ordered]@{
        '$schema'      = "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#"
        contentVersion = "1.0.0.0"
        parameters     = $script:ArmParameters
        variables      = [pscustomobject]@{}
        resources      = @()
        outputs        = [pscustomobject]@{}
    }

    $ArmParameters `
        | Remove-InternalProperty `
        | Remove-ExtraBracketInArmTemplateFunction `
        | ConvertTo-Json -Depth 99 `
        | Format-Json `
        | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) } `
        | Out-File -FilePath $TemplateParameterFilePath

    Write-Verbose "Template parameters created successfully `n $TemplateParameterFilePath"
}