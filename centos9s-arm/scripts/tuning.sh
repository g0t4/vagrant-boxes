#!/bin/bash -eux

# from https://github.com/lavabit/robox/blob/master/scripts/centos9s/tuning.sh

retry() {
  local COUNT=1
  local DELAY=0
  local RESULT=0
  while [[ "${COUNT}" -le 10 ]]; do
    [[ "${RESULT}" -ne 0 ]] && {
      [ "`which tput 2> /dev/null`" != "" ] && [ -n "$TERM" ] && tput setaf 1
      echo -e "\n${*} failed... retrying ${COUNT} of 10.\n" >&2
      [ "`which tput 2> /dev/null`" != "" ] && [ -n "$TERM" ] && tput sgr0
    }
    "${@}" && { RESULT=0 && break; } || RESULT="${?}"
    COUNT="$((COUNT + 1))"

    # Increase the delay with each iteration.
    DELAY="$((DELAY + 10))"
    sleep $DELAY
  done

  [[ "${COUNT}" -gt 10 ]] && {
    [ "`which tput 2> /dev/null`" != "" ] && [ -n "$TERM" ] && tput setaf 1
    echo -e "\nThe command failed 10 times.\n" >&2
    [ "`which tput 2> /dev/null`" != "" ] && [ -n "$TERM" ] && tput sgr0
  }

  return "${RESULT}"
}

# TODO keep tuned? or not? look into impact on perf at some point?
# Configure tuned
retry dnf --assumeyes install tuned
systemctl enable tuned
systemctl start tuned

# Set the profile to virtual guest.
tuned-adm profile virtual-guest

# Configure grub to wait just 1 second before booting
sed -i -e 's/^GRUB_TIMEOUT=[0-9]\+$/GRUB_TIMEOUT=1/' /etc/default/grub
# For UEFI systems.
[ -f /etc/grub2-efi.cfg  ] && grub2-mkconfig -o /etc/grub2-efi.cfg 
# For BIOS systems.
[ -f /etc/grub2.cfg ] && grub2-mkconfig -o /etc/grub2.cfg

# TODO do I need to modify grub timeout? ubuntu-2310 box doesn't pause on boot (not w/ vagrant up which is really all I care about)