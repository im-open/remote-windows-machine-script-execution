# Remote Windows Machine Script Execution

This action connects to an on-premises hosted windows machine and executes a PowerShell script.

## Index <!-- omit in toc -->

- [Inputs](#inputs)
- [Prerequisites](#prerequisites)
- [Example](#example)
- [References](#references)
- [Contributing](#contributing)
  - [Incrementing the Version](#incrementing-the-version)
- [Code of Conduct](#code-of-conduct)
- [License](#license)

## Inputs

| Parameter                  | Is Required | Description                                                                  |
| -------------------------- | ----------- | ---------------------------------------------------------------------------- | -------------------------------------------------------------- | ---- | ----- |
| `script-path`              | true        | The local repository path to the script to be executed on the remote machine |
| `script-arguments`         | false       | A pipe delimited string, `                                                   | `, that contains the arguments for the script - Example: `arg1 | arg2 | arg3` |
| `server`                   | true        | The name of the target server                                                |
| `service-account-id`       | true        | The service account name                                                     |
| `service-account-password` | true        | The service account password                                                 |

## Prerequisites

The remote script execution action uses Web Services for Management, [WSMan], and Windows Remote Management, [WinRM], to create remote administrative sessions. Because of this, Windows Action Runners, `runs-on: [windows-2019]`, must be used. If the IIS server target is on a local network that is not publicly available, then specialized self-hosted runners, `runs-on: [self-hosted, windows-2019]`, will need to be used to broker commands to the server.

Inbound secure WinRm network traffic (TCP port 5986) must be allowed from the GitHub Actions Runners virtual network so that remote sessions can be received.

Prep the remote IIS server to accept WinRM management calls. In general the IIS server needs to have a [WSMan] listener that looks for incoming [WinRM] calls. Firewall exceptions need to be added for the secure WinRM TCP ports, and non-secure firewall rules should be disabled. More detailed information on the preparation of an on-prem server can be found in this article: [PowerShell Remoting over HTTPS with a self-signed SSL certificate]

Here is an example script that would be run on the IIS server:

```powershell
$Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName <<ip-address|fqdn-host-name>>

Export-Certificate -Cert $Cert -FilePath C:\temp\<<cert-name>>

Enable-PSRemoting -SkipNetworkProfileCheck -Force

# Check for HTTP listeners
dir wsman:\localhost\listener

# If HTTP Listeners exist, remove them
Get-ChildItem WSMan:\Localhost\listener | Where -Property Keys -eq "Transport=HTTP" | Remove-Item -Recurse

# If HTTPs Listeners don't exist, add one
New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint –Force

# This allows old WinRm hosts to use port 443
Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener -Value true

# Make sure an HTTPs inbound rule is allowed
New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "Windows Remote Management (HTTPS-In)" -Profile Any -LocalPort 5986 -Protocol TCP

# For security reasons, you might want to disable the firewall rule for HTTP that *Enable-PSRemoting* added:
Disable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"
```

- `ip-address` or `fqdn-host-name` can be used for the `DnsName` property in the certificate creation. It should be the name that the actions runner will use to call to the IIS server.
- `cert-name` can be any name. This file will used to secure the traffic between the actions runner and the IIS server

## Example

```yml
...

jobs:
  execute-remote-script:
   runs-on: [windows-2019]
   env:
      server: 'remote-server.domain.com'

   steps:
    - name: Checkout
      uses: actions/checkout@v3

    - name: Execute Script
      uses: 'im-open/remote-windows-machine-script-execution@v2.0.2'
      with:
        script-path: './execute-script.ps1'
        script-arguments:  'arg1|arg2|arg3'
        server: ${{ env.server }}
        service-account-id: ${{ secrets.iis_admin_user }}
        service-account-password: ${{ secrets.iis_admin_password }}
  ...
```

It's important to note that the contents of the script are:

> ...copied into a script block and the script block is run on each of the remote computers. This procedure is equivalent to using the ScriptBlock parameter to submit the contents of the script.[[1](#1)]

## References

<a id="1">1.</a> [PowerShell: Invoke-Command](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/invoke-command?view=powershell-7.1)

## Contributing

When creating new PRs please ensure:

1. For major or minor changes, at least one of the commit messages contains the appropriate `+semver:` keywords listed under [Incrementing the Version](#incrementing-the-version).
2. The `README.md` example has been updated with the new version. See [Incrementing the Version](#incrementing-the-version).
3. The action code does not contain sensitive information.

### Incrementing the Version

This action uses [git-version-lite] to examine commit messages to determine whether to perform a major, minor or patch increment on merge. The following table provides the fragment that should be included in a commit message to active different increment strategies.
| Increment Type | Commit Message Fragment |
| -------------- | ------------------------------------------- |
| major | +semver:breaking |
| major | +semver:major |
| minor | +semver:feature |
| minor | +semver:minor |
| patch | _default increment type, no comment needed_ |

## Code of Conduct

This project has adopted the [im-open's Code of Conduct](https://github.com/im-open/.github/blob/master/CODE_OF_CONDUCT.md).

## License

Copyright &copy; 2021, Extend Health, LLC. Code released under the [MIT license](LICENSE).

<!-- Links -->

[git-version-lite]: https://github.com/im-open/git-version-lite
[powershell remoting over https with a self-signed ssl certificate]: https://4sysops.com/archives/powershell-remoting-over-https-with-a-self-signed-ssl-certificate
[wsman]: https://docs.microsoft.com/en-us/windows/win32/winrm/ws-management-protocol
[winrm]: https://docs.microsoft.com/en-us/windows/win32/winrm/about-windows-remote-management
