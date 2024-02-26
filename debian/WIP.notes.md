# TODO

NEXT UP need to add/review scripts and that should be about it!!
   FYI scripts as is worked, last build failed on shutdown command issue and then timed out waiting after I manually turned it off... must've just ran out of time which is fine b/c then it won't publish a build w/o script mods :)
    sudo worked in `sudo systemctl poweroff`
    FYI bento uses (AFICT for debian):
      echo 'vagrant' | sudo -S /sbin/halt -h -p
      # I don't think I need to pass the password, the first shutdown is after passwordless sudo is setup

### bento script review

- networking_debian.sh
  - not adding unless an issue arises
    - don't disable predictable network interface naming
      - esp b/c I expect VMs to have multiple nics so eth0 alone isn't gonna cut it
    - add 2 seconds for /etc/network/interfaces? for dhcp?
- cleanup_debian  done for now
- hyperv_debian.sh skip
- sudoers_debian.sh REVIEW
- systemd_debian.sh REVIEW
- update_debian.sh REVIEW
- ALSO review any extra scripts I already have from ubuntu2310 copy pasta

### PRN robox script review

- https://github.com/lavabit/robox/blob/master/scripts/debian12/apt.sh