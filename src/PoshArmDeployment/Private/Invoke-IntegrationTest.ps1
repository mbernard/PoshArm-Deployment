function Invoke-IntegrationTest {
    param([parameter(Mandatory = $true)]
        [ScriptBlock]
        $ArmResourcesScriptBlock)

    {
        Publish-ArmResourceGroup -ResourceGroupName "posharm-test2" -Test -ArmResourcesScriptBlock $ArmResourcesScriptBlock `
        | Should -BeNullOrEmpty
    } | Should -Not -Throw
}