# TODO

NEXT UP need to add/review scripts and that should be about it!!
   FYI scripts as is worked, last build failed on shutdown command issue and then timed out waiting after I manually turned it off... must've just ran out of time which is fine b/c then it won't publish a build w/o script mods :)
    sudo worked in `sudo systemctl poweroff`
    FYI bento uses (AFICT for debian):
      echo 'vagrant' | sudo -S /sbin/halt -h -p
      # I don't think I need to pass the password, the first shutdown is after passwordless sudo is setup

### bento script review


- network.sh
  - PRN disable ipv6 if have build issues, i.e. vagrant tty bug can be related to ipv6... but lets not do this if its not an issue for me
    - https://github.com/lavabit/robox/blob/eadba7cd7a3aa58e6f6f2f3e92fc51585ab2828b/scripts/debian12/network.sh#L34-L40
  - set hostname?
    - https://github.com/lavabit/robox/blob/eadba7cd7a3aa58e6f6f2f3e92fc51585ab2828b/scripts/debian12/network.sh#L43-L45
  - 

### PRN robox script review

- https://github.com/lavabit/robox/blob/master/scripts/debian12/apt.sh