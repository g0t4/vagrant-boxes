set -x

export USEROPTS="-f foobar -u foobar" # script prompts if use -g 'blah balh' inside so jsut nuke that - I dont even want this user I just want the script to stop prompting so foobar leaves it all alone

wget "https://raw.githubusercontent.com/hashicorp/vagrant/5b501a3fb05ed0ab16cf10991b3df9d231edb5cf/keys/vagrant.pub"

# setup-user ${USERSSHKEY+-k "$USERSSHKEY"} ${USEROPTS:--a -g 'audio video netdev'}

set +x