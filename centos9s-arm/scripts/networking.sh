# sync with debian/scripts/networking.sh

# hostname
sudo hostnamectl set-hostname centos9s
sudo sed -i "s/127.0.1.1\s.*/127.0.1.1\tcentos9s/g" /etc/hosts
