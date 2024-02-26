#!/bin/sh -eux

# hostname
sudo hostnamectl set-hostname debian12
sudo sed -i "s/127.0.1.1\s.*/127.0.1.1\tdebian12/g" /etc/hosts

# PRN add delay? both bento and robox have this:
# printf "pre-up sleep 2\n" >> /etc/network/interfaces

# bento/networking_debian.sh
# PRN (if issues): don't disable predictable network interface naming, esp b/c I expect VMs to have multiple nics so eth0 alone isn't gonna cut it

# set nameservers?

# FYI robox/networking.sh has many other configs that I might want... it also gets into eth0 naming (not sure the same) PRN review when I care
