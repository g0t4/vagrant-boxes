#!/bin/sh -eux

# TODO validate if needed:
# apparently, SSH sessions hang on shutdown (I might've experienced this already when I had that shutdown time out even after I manually shut the VM down)

# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=751636
apt-get install libpam-systemd
