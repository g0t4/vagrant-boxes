#!/bin/sh -eux

dnf --assumeyes update

# packages to install (include already installed, not worth it to double check each release)
dnf --assumeyes install \
  bash-completion \
  mlocate \
  rsync \
  vim-enhanced \
  bind-utils \
  wget \
  dos2unix unix2dos \
  lsof \
  telnet \
  net-tools \
  patch \
  sysstat \
  make \
  cmake \
  autoconf \
  automake \
  libtool \
  ncurses-devel \
  glibc-headers

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  apt-file \
  bash-completion \
  command-not-found \
  curl wget \
  fish \
  grc \
  iproute2 \
  lsof \
  procps \
  psmisc \
  silversearcher-ag \
  tree \
  util-linux \
  vim