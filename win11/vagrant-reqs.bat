REM from https://developer.hashicorp.com/vagrant/docs/boxes/base

REM disable UAC
reg add HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /d 0 /t REG_DWORD /f /reg:64
REM TODO - reboot after disable UAC

REM MUST HAVE PRVIATE NETWORK TYPE BEFORE winrm config:

REM run from cmd.exe (not pwsh)
REM winrm config
winrm quickconfig -q
winrm set winrm/config/winrs @{MaxMemoryPerShellMB="512"}
winrm set winrm/config @{MaxTimeoutms="1800000"}
winrm set winrm/config/service @{AllowUnencrypted="true"}
winrm set winrm/config/service/auth @{Basic="true"}
sc config WinRM start= auto
REM CHECK FOR ERRORS in all these commands (lots of config output can obscure a failure - will fail if not in cmd.exe or bat file)