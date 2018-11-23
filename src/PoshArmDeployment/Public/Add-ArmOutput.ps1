function Add-ArmOutput {
    [cmdletbinding()]
    Param(
        [PSTypeName('ArmTemplate')]
        $Template,
        [Parameter(Mandatory)]
        [string]
        $Name,
        [Parameter(Mandatory)]
        [ValidateSet("string", "securestring", "int", "bool", "object", "secureObject", "array")]
        [string]
        $Type,
        [Parameter(Mandatory)]
        $Value
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
            $propHash = [ordered]@{
                type  = $Type
                value = $Value
            }
            $Template.outputs | Add-Member -MemberType NoteProperty -Name $Name -Value $propHash
        }
    }

    End {
        Write-Verbose -Message "$f - End"
    }
}