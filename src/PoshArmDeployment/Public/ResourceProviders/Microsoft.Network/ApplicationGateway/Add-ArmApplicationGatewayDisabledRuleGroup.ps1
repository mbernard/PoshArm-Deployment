function Add-ArmApplicationGatewayDisabledRuleGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationGateway")]
    Param(
        [PSTypeName("ApplicationGateway")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationGateway,
        [Parameter(Mandatory)]
        [string]
        $RuleGroupName,
        [Parameter(Mandatory)]
        [int[]]
        $Rules
    )

    If ($PSCmdlet.ShouldProcess("Adding web application firewall disabled rules")) {
        $disabledRuleGroup = @{
            ruleGroupName = $RuleGroupName
            rules         = $Rules
        }

        $ApplicationGateway.properties.webApplicationFirewallConfiguration.disabledRuleGroups += $disabledRuleGroup

        return $ApplicationGateway
    }
}