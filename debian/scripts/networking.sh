# PRN disable ipv6 if have build issues, i.e. vagrant tty bug can be related to ipv6... but lets not do this if its not an issue for me
#   PRN run before apt update? maybe => FYI maybe just combine all these setup scripts so it is obvious the order
# https://github.com/lavabit/robox/blob/eadba7cd7a3aa58e6f6f2f3e92fc51585ab2828b/scripts/debian12/network.sh#L34-L40


# set hostname?
# https://github.com/lavabit/robox/blob/eadba7cd7a3aa58e6f6f2f3e92fc51585ab2828b/scripts/debian12/network.sh#L43-L45

# PRN add delay? both bento and robox have this:
# printf "pre-up sleep 2\n" >> /etc/network/interfaces

# bento/networking_debian.sh
# PRN (if issues): don't disable predictable network interface naming, esp b/c I expect VMs to have multiple nics so eth0 alone isn't gonna cut it

# set nameservers?

# FYI robox/networking.sh has many other configs that I might want... it also gets into eth0 naming (not sure the same) PRN review when I care
