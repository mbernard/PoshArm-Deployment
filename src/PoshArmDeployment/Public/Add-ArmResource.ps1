function Add-ArmResource {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSTypeName('ArmResource')]
        $InputObject,
        [PSTypeName('Armtemplate')]
        $Template,
        [switch]
        $PassThru
    )

    Begin {
        $f = $MyInvocation.InvocationName
        Write-Verbose -Message "$f - START"
    }

    Process {
        if (-not $Template) {
            Write-Verbose -Message "$f -  Using module level template"
            $Template = $script:ArmTemplate
        }

        if ($Template) {
            $Template.resources += $InputObject
        }

        if ($PassThru.IsPresent) {
            $InputObject
        }
    }

    End {
        Write-Verbose -Message "$f - End"
    }
}