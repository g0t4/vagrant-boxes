# $ErrorActionPreference = Continue ?? set or not?
# Reminder: Run AS Admin!

# set clipboard to bidirectional for copy/pasta this stuff

# accepts are to bypass any additional prompts (including first agreement to source)
winget install --silent --accept-source-agreements `
  --accept-package-agreements `
  Microsoft.PowerShell.Preview

# agree with Y yes
# install before sshd setup - using pwsh-preview.cmd as default shell

# must be run before vagrant's suggested winrm config
if((Get-NetConnectionProfile).NetworkCategory -ne "Private"){
  echo "not private network profile, changing to private..."
  Set-NetConnectionProfile -NetworkCategory Private
}

# fix winssh comm progress bar issues with posh:
#   https://developer.hashicorp.com/vagrant/docs/boxes/base#optional-winssh-configuration
if (!(Test-Path -Path $PROFILE)) {
  New-Item -ItemType File -Path $PROFILE -Force
}
Add-Content $PROFILE '$ProgressPreference = "SilentlyContinue"'


# optional
# winget install --silent Microsoft.WindowsTerminal.Preview
update-help -ErrorAction continue

# windows features/capabilities: 
#  TODO add any?
#   Get-WindowsOptionalFeature -Online -FeatureName *foo* 
#   Get-WindowsCapability -Online -Name *foo* 

# SMB for shared folder in vagrant?

