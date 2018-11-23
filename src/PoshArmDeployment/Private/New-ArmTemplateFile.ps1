function New-ArmTemplateFile {
    [CmdletBinding(SupportsShouldProcess = $True)]
    param(
        [string]
        [Parameter(Mandatory)]
        $TemplateFilePath
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm template file")) {
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
}