#!/bin/sh -eux

sudo hostnamectl set-hostname arch
sudo sed -i "s/127.0.1.1\s.*/127.0.1.1\tarch/g" /etc/hosts
