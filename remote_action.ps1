Param(
    [parameter(Mandatory = $true)]
    [string]$script_path,
    [parameter(Mandatory = $false)]
    [string]$script_arguments,
    [parameter(Mandatory = $true)]
    [string]$server,
    [parameter(Mandatory = $true)]
    [string]$user_id,
    [parameter(Mandatory = $true)]
    [SecureString]$password,
    [parameter(Mandatory = $true)]
    [string]$cert_path
)

$display_action = 'Execute Remote Script'
$display_action_past_tense = "Remote Script Executed"

Write-Output $display_action
Write-Output "Server: $server"

$credential = [PSCredential]::new($user_id, $password)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

Write-Output "Importing remote server cert..."
Import-Certificate -Filepath $cert_path -CertStoreLocation 'Cert:\LocalMachine\Root'

$args = $script_arguments -split '\|'

Invoke-Command `
    -FilePath $script_path `
    -ArgumentList $args `
    -ComputerName $server `
    -Credential $credential `
    -UseSSL `
    -SessionOption $so

Write-Output $display_action_past_tense
