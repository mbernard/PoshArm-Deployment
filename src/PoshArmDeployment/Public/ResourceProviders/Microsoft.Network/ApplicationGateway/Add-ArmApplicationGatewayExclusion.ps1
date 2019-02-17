function Add-ArmApplicationGatewayExclusion {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationGateway")]
    Param(
        [PSTypeName("ApplicationGateway")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationGateway,
        [Parameter(Mandatory)]
        [ValidateSet('RequestHeaderNames', 'RequestCookieNames', 'RequestArgNames')]
        [string]
        $MatchVariable,
        [Parameter(Mandatory)]
        [ValidateSet('StartsWith', 'EndsWith', 'Contains', 'Equals')]
        [string]
        $SelectorMatchOperator,
        [Parameter(Mandatory)]
        [string]
        $Selector
    )

    If ($PSCmdlet.ShouldProcess("Adding web application firewall exclusion")) {
        $exclusion = @{
            matchVariable         = $MatchVariable
            selectorMatchOperator = $SelectorMatchOperator
            selector              = $Selector
        }

        $ApplicationGateway.properties.webApplicationFirewallConfiguration.exclusions += $exclusion

        return $ApplicationGateway
    }
}