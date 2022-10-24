#!/bin/bash -eux

printf "\n127.0.0.1    alpine316 alpine316.localdomain\n" >>/etc/hosts
echo "alpine316.localdomain" >/etc/hostname
hostname alpine316.localdomain
