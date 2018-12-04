function Add-ArmServiceFabricClientCertificate {
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param(
        [PSTypeName("ServiceFabricCluster")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ServiceFabricCluster,
        [string]
        [Parameter(Mandatory)]
        $CertificateThumbprint,
        [Switch]
        $Admin
    )

        If ($PSCmdlet.ShouldProcess("Adding client certificate to service fabric cluster")) {
            $ServiceFabricCluster.properties.clientCertificateThumbprints += @{
               isAdmin = $Admin.ToBool()
               certificateThumbprint = $CertificateThumbprint
            }
        }

        return $ServiceFabricCluster
}