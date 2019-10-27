function Invoke-IntegrationTest {
    param([parameter(Mandatory = $true)]
        [ScriptBlock]
        $ArmResourcesScriptBlock)

    {
        $output = Publish-ArmResourceGroup -ResourceGroupName "posharm-test2" -Test -ArmResourcesScriptBlock $ArmResourcesScriptBlock
        $output | Should -BeNullOrEmpty -Because $output.message
    } | Should -Not -Throw
}