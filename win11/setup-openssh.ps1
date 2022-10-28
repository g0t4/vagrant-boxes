# Guide: https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=powershell

Set-ExecutionPolicy RemoteSigned # need for profile below (at least)
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# Ensure Firewall rule exists (should already be there)
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue)) {
    
    Write-Output "Creating missing firewall rule 'OpenSSH-Server-In-TCP'..."

    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' `
        -DisplayName 'OpenSSH Server (sshd)' `
        -Enabled True `
        -Direction Inbound `
        -Protocol TCP `
        -Action Allow `
        -LocalPort 22

}
# todo - what about checking that it's enabled?! that wasn't in guide?


# default shell:
#   https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_server_configuration#configuring-the-default-shell-for-openssh-in-windows
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" `
    -Name DefaultShell `
    -Value "C:\Program Files\PowerShell\7-preview\pwsh.exe" `
    -PropertyType String `
    -Force
    # won't be in path (just installed above - not until restart will updated path be avail so don't use gcm here to find pwsh-preview.cmd)
    # -Value "$((gcm pwsh-preview.cmd).Source)" `

# todo other config? 
#   ssh server config: 
#       https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_server_configuration
#   client/account config:
#       add vagrant insecure key to vagrant user, others?
#       
# NOTE: test with:
#  ssh localhost
#    accept key
#    opens CMD.exe right now... yuck TODO fix

# config:
#  app: C:\Windows\System32\OpenSSH
#  data:  C:\ProgramData\ssh
#   notable:
#     C:\ProgramData\ssh\sshd_config
#     C:\ProgramData\ssh\ssh_host_*_key[.pub]
#     can get fingerprint to confirm when initiating first remote connection
#       ssh-keygen.exe -lf C:\ProgramData\ssh\ssh_host_ecdsa_key.pub