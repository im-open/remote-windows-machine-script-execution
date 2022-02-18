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
    [SecureString]$password
)

$display_action = 'Execute Remote Script'
$display_action_past_tense = "Remote Script Executed"

Write-Output $display_action
Write-Output "Server: $server"

$credential = [PSCredential]::new($user_id, $password)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

Invoke-Command `
    -FilePath $script_path `
    -ArgumentList $script_arguments -split '\|' `
    -ComputerName $server `
    -Credential $credential `
    -UseSSL `
    -SessionOption $so

Write-Output $display_action_past_tense
