function Get-ArmFunctionResourceId {
    [cmdletbinding(DefaultParameterSetName = 'Resource')]
    [OutputType([string])]
    Param(
        [Parameter(Mandatory, ParameterSetName = "TypeAndName", ValueFromPipeline)]
        [string]
        $ResourceName1,
        [Parameter(ParameterSetName = "TypeAndName")]
        [string]
        $ResourceName2,
        [Parameter(ParameterSetName = "Resource")]
        [PSCustomObject]
        $Resource,
        [Parameter(ParameterSetName = "TypeAndName")]
        [Parameter(ParameterSetName = 'ResourceGroupSpecific', Mandatory)]
        [Parameter(ParameterSetName = 'SubscriptionSpecific', Mandatory)]
        [string]
        $ResourceGroupName,
        [Parameter(ParameterSetName = "TypeAndName")]
        [Parameter(ParameterSetName = 'SubscriptionSpecific', Mandatory)]
        [string]
        $SubscriptionId
    )
    DynamicParam {
        Add-ResourceTypeDynamicParameter
    }
    Begin {
        $ResourceProvider = Get-SupportedResourceProvider | Where-Object resourceType -eq $PSBoundParameters['ResourceType']
    }
    Process {

        if ($PSCmdlet.ParameterSetName -eq "Resource") {
            $ResourceType = $Resource.type
            $ResourceName1 = $resource.name
        }
        else {
            $ResourceType = $ResourceProvider.resourceType
        }

        if ($ResourceName1.Contains("/")) {
            $name = $ResourceName1
            $i = $name.IndexOf("/")
            $ResourceName1 = $name.Substring(0, $i)
            $ResourceName2 = $name.Substring($i + 1, $name.Length - $i - 1)
        }

        $arguments = @($ResourceType, $ResourceName1)

        if (![string]::IsNullOrEmpty($ResourceGroupName)) {
            $arguments = @($ResourceGroupName) + $arguments
        }

        if (![string]::IsNullOrEmpty($SubscriptionId)) {
            $arguments = @($SubscriptionId) + $arguments
        }

        if (![string]::IsNullOrEmpty($ResourceName2)) {
            $arguments = $arguments + @($ResourceName2)
        }

        $resourceIdParams = ([string]::Join(',', ($arguments | ForEach-Object {"'$_'"})))
        "[resourceId($resourceIdParams)]"
    }
}