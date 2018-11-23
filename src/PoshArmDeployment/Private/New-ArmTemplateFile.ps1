function New-ArmTemplateFile {
    [CmdletBinding()]
    param(
        [string]
        [Parameter(Mandatory)]
        $TemplateFilePath
    )

    # Sanitize the arm template object by removing internal properties and extra [] in template function
    $script:ArmTemplate `
        | Remove-InternalProperty `
        | Remove-ExtraBracketInArmTemplateFunction `
        | ConvertTo-Json -Depth 99 `
        | Format-Json `
        | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) } `
        | Out-File -FilePath $TemplateFilePath

    Write-Verbose "Template created successfully `n $TemplateFilePath"
}