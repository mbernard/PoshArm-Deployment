function Add-ArmParameter {
    [CmdletBinding(SupportsShouldProcess = $True)]
    Param(
        [PSTypeName("ArmParameter")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject,
        [PSTypeName('ArmTemplate')]
        $Template,
        [switch]
        $PassThru
    )

    Begin {
        $f = $MyInvocation.InvocationName
        Write-Verbose -Message "$f - START"
    }

    Process {
        If ($PSCmdlet.ShouldProcess("Creates a new Arm parameter")) {
            if (-not $Template) {
                Write-Verbose -Message "$f -  Using module level template"
                $Template = $script:ArmTemplate
            }

            if ($Template) {
                $props = $InputObject.PSobject.Properties | Where-Object { !$_.Name.StartsWith("_") }
                foreach ($prop in  $props) {
                    $value = $prop.Value
                    $Template.parameters | Add-Member -MemberType NoteProperty -Name $prop.Name -Value $value
                }
            }

            if ($PassThru.IsPresent) {
                $InputObject
            }
        }
    }

    End {
        Write-Verbose -Message "$f - End"
    }
}