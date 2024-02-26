# sync with debian/scripts/networking.sh

# hostname
sudo hostnamectl set-hostname ubuntu
sudo sed -i "s/127.0.1.1\s.*/127.0.1.1\tubuntu/g" /etc/hosts
