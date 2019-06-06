function Set-ArmApplicationGatewaySslPolicy {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationGateway")]
    Param(
        [PSTypeName("ApplicationGateway")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationGateway,
        [Parameter(ParameterSetName = "Predefined", Mandatory)]
        [ValidateSet("AppGwSslPolicy20150501", "AppGwSslPolicy20170401", "AppGwSslPolicy20170401S")]
        [string]
        $PolicyName,
        [Parameter(ParameterSetName = "Custom", Mandatory)]
        [ValidateSet("TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
            "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
            "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384",
            "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256",
            "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA",
            "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA",
            "TLS_DHE_RSA_WITH_AES_256_GCM_SHA384",
            "TLS_DHE_RSA_WITH_AES_128_GCM_SHA256",
            "TLS_DHE_RSA_WITH_AES_256_CBC_SHA",
            "TLS_DHE_RSA_WITH_AES_128_CBC_SHA",
            "TLS_RSA_WITH_AES_256_GCM_SHA384",
            "TLS_RSA_WITH_AES_128_GCM_SHA256",
            "TLS_RSA_WITH_AES_256_CBC_SHA256",
            "TLS_RSA_WITH_AES_128_CBC_SHA256",
            "TLS_RSA_WITH_AES_256_CBC_SHA",
            "TLS_RSA_WITH_AES_128_CBC_SHA",
            "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
            "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
            "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384",
            "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256",
            "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA",
            "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA",
            "TLS_DHE_DSS_WITH_AES_256_CBC_SHA256",
            "TLS_DHE_DSS_WITH_AES_128_CBC_SHA256",
            "TLS_DHE_DSS_WITH_AES_256_CBC_SHA",
            "TLS_DHE_DSS_WITH_AES_128_CBC_SHA",
            "TLS_RSA_WITH_3DES_EDE_CBC_SHA",
            "TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA")]
        [string[]]
        $CipherSuites,
        [Parameter(ParameterSetName = "Predefined")]
        [Parameter(ParameterSetName = "Custom", Mandatory)]
        [ValidateSet("TLSv1_0", "TLSv1_1", "TLSv1_2")]
        [string]
        $MinProtocolVersion,
        [Parameter(ParameterSetName = "Predefined")]
        [Parameter(ParameterSetName = "Custom")]
        [ValidateSet("TLSv1_0", "TLSv1_1", "TLSv1_2")]
        [string[]]
        $DisabledProtocolVersions
    )

    If ($PSCmdlet.ShouldProcess("Adding SSL policy")) {
        if ($PSCmdlet.ParameterSetName -eq "Predefined") {
            $SslPolicy = [PSCustomObject][ordered]@{
                policyType = "Predefined"
                policyName = $PolicyName
            }
        }
        elseif ($PSCmdlet.ParameterSetName -eq "Custom") {
            $SslPolicy = [PSCustomObject][ordered]@{
                policyType   = "Custom"
                cipherSuites = $CipherSuites
            }
        }

        if ($MinProtocolVersion) {
            $SslPolicy | Add-Member -MemberType NoteProperty -Name "minProtocolVersion" -Value $MinProtocolVersion
        }

        if ($DisabledProtocolVersions) {
            $SslPolicy | Add-Member -MemberType NoteProperty -Name "disabledSslProtocols" -Value $DisabledProtocolVersions
        }

        $ApplicationGateway.properties.sslPolicy = $SslPolicy

        return $ApplicationGateway
    }
}