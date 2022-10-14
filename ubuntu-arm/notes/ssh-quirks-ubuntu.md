# SSH quirks with ubuntu's `autoinstall` (unattended installs)

- packer's `boot_command` launches ubuntu's `autoinstall` to automate installing from the `ISO`
  - after this packer waits/attempts to connect over SSH
    - SSH being available is the mechanism whereby packer knows a machine is ready for provisioning
- quirk: ubuntu runs an SSH server during autoinstall (unattended install)
  - the password is random so packer won't successfully connect
    - thankfully, as we can't have provisioning start until after autoinstall is completed!
  - with default config, packer will attempt to connect until it hits max `ssh_handshake_attempts`
    - and then packer fails the build
      - before the guest is even ready to be provisioned!
- workaround:
  - partial fix:
    - disable SSH server in autoinstall's `early` commands
      - not sure if this causes issues for autoinstaller?
        - It didn't in my initial testing
        - and I've seen other people use this.
    - midway through `autoinstall` the SSH server will be **restarted** anyways!
      - this isn't an issue for fast installs (ie Ubuntu 22.04.1 autoinstall is < 2 minutes)
      - this is an issue for slower autoinstalls (ie 22.10 beta ~ 4.5 minutes)
  - current fix:
    - Add a `<waitN>` to the end of the `boot_command`
      - thus deferring packer's first attempt to connect to the SSH server
    - Because the amount of time is indeterminate:
      - Either have to overestimate time for worst case build and slow down all builds
      - Or, find another way to handle at least some of the SSH failures...
        - remember packer won't successfully connect to the wrong SSH server (random password)
    - So, I went with:
      - Small wait at end of `boot_command` currently at `<wait4>` 4 minutes
        - based on timing of ubuntu 22.10 beta builds... I will likely adjust this
      - Plus, increased the [`ssh_handshake_attempts`](https://www.packer.io/docs/communicators/ssh#ssh_handshake_attempts)
        - to allow for more than 10 failures to connect thus if the build runs over 4 minutes it still has 20 failures before the build is failed (can bump it up if need be)
      - Thus I will have a few failed attempts after fixed wait time but then those are ignored (if under 20) so that install can finish and reboot -> thus allowing packer to connect and provision!
    - TODO see if failure attempts alone works?
      - Can I just crank failure attempts really high (say 100) and see if that works for longer autoinstalls?
      - This would avoid holding up faster autoinstalls
    - CHECK packer config for latest values
      - I'm likely to forget to update this if I go another direction with the fix ;)...
- links:
  - here's a 20.04 packer example that has ssh_handshake_attempts = 20 too
    - https://imagineer.in/blog/packer-build-for-ubuntu-20-04/
  - large discussion of various issues with 20.04, notably the autoinstall SSH server and what people attempted:
    - https://github.com/hashicorp/packer/issues/9115