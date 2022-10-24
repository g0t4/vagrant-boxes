#cat > /etc/sysctl.d/noipv6.conf <<EOF
# todo why isn't sysctl.d/foo.conf working?
# temp for now just write to /etc/sysctl.conf which works
cat >/etc/sysctl.conf  <<EOF
# Force IPv6 off
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.ipv6.conf.eth0.disable_ipv6 = 1
EOF

# reload
sysctl -p

# now ipv6 is disable, and internets work again!