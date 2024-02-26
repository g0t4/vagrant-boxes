#!/bin/sh -eux

dnf --assumeyes update

# already installed
dnf --assumeyes install dmidecode coreutils grep gawk sed curl \
  psmisc libarchive gcc-c++ libstdc++-devel cpp glibc-devel

# not already installed
dnf --assumeyes install bash-completion mlocate \
  rsync vim-enhanced bind-utils wget dos2unix unix2dos lsof telnet \
  net-tools patch sysstat make cmake autoconf automake libtool \
  ncurses-devel glibc-headers
