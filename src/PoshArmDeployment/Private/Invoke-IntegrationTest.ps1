function Invoke-IntegrationTest {
    param([parameter(Mandatory = $true)]
        [ScriptBlock]
        $ArmResourcesScriptBlock)

    $output = Publish-ArmResourceGroup -ResourceGroupName "posharm-test" -Test -ArmResourcesScriptBlock $ArmResourcesScriptBlock -ErrorAction Stop
    $output | Should -BeNullOrEmpty -Because $output.message
}