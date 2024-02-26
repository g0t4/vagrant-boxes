#!/bin/sh -eux

sudo dnf --assumeyes update

sudo dnf --assumeyes install epel-release
# bat found in epel via https://koji.fedoraproject.org/koji/packageinfo?packageID=27506

# packages to install (include already installed, not worth it to double check each release)
sudo dnf --assumeyes install \
  bash-completion \
  bat \
  bind-utils \
  curl wget \
  dos2unix \
  fish \
  iproute \
  lsof \
  procps \
  psmisc \
  rsync \
  sysstat \
  telnet \
  the_silver_searcher \
  tree \
  util-linux \
  util-linux-user \
  vim-enhanced
  # not avail:
  #   grc
  # no:
  #   PackageKit-command-not-found \
  #     confusion when command hangs and I am less of a fan of being prompted (default) to install it... I'd rather be told about a package and that is it... just add this downstream in Vagrantfile shell provisioners
  #     also `dnf whatprovides foo` exists
  #   pipx \
