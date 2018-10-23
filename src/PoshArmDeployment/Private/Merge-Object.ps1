function Merge-Object {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [PSCustomObject]
        $base,
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSCustomObject]
        $ext
    )

    # Important to force a cast to PSCustomObject otherwise HashTables could cause an error
    $base = [PSCustomObject]$base
    $ext = [PSCustomObject]$ext

    $propNames = $($ext | Get-Member -MemberType *Property).Name
    foreach ($propName in $propNames) {
        if ($base.PSObject.Properties.Match($propName).Count) {
            if ($base.$propName.GetType().Name -eq "PSCustomObject") {
                $base.$propName = Merge-Object -base $base.$propName -ext $ext.$propName
            }
            else {
                $base.$propName = $ext.$propName
            }
        }
        else {
            $base | Add-Member -MemberType NoteProperty -Name $propName -Value $ext.$propName
        }
    }

    return $base
}