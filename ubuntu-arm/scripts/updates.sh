#!/bin/sh -eux

sudo DEBIAN_FRONTEND=noninteractive apt-get -y update

sudo DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
