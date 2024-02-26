#!/bin/sh -eux

# TODO validate if needed:
# apparently, SSH sessions hang on shutdown (I might've experienced this already when I had that shutdown time out even after I manually shut the VM down)

# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=751636
apt-get install libpam-systemd

# I had a hang on ssh when packer cleaned up the VM (I was ssh'd in) so this may be an issue, that said using systemctl shutdown may not trigger the hang as it didn't do it the time before when I manually did it that way