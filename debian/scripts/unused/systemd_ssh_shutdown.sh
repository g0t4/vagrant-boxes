#!/bin/sh -eux

# apparently, SSH sessions hang on shutdown
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=751636
apt-get install libpam-systemd

# I have not needed this so far, will add if needed later.
