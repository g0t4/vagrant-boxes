# enable time sync (avoids time drift in demos when VM is off for a while)
#  if you need to demo time drift problems, then disable this downstream in a provision step)
timedatectl set-ntp true
