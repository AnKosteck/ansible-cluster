#!/bin/bash

###
### first_start.sh
### Use this script to set up the basic system
###

function print_section() {
  echo ""
  echo "################ [$1]"
}

# Setting facts
#TODO Set your own facts, execute as root
declare -A NEEDED_HOSTS=(["192.168.1.254"]="$(hostname) $(hostname -f) $(hostname -s)" ["192.168.1.15"]="needed_host_X")
HEXA_HTTPS_LINK="https://github.com/AnKosteck/Hexa.git"
#HEXA_SSH_LINK="git@github.com:AnKosteck/Hexa.git"
REPO_NAME="Hexa"
HOSTS_FILE="hexa_hosts_example"
FORKS="5"

# Install ansible and git
print_section "Install ansible and git"
yum -y install epel-release
yum -y upgrade epel-release
yum -y install ansible git

# SSH Key management
print_section "SSH key creation"
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
ssh-keygen -f ~/.ssh/id_ecdsa -t ecdsa -N ''
cat ~/.ssh/id_ecdsa.pub >> ~/.ssh/authorized_keys

# Write hosts information
print_section "Editing /etc/hosts"
for IP in "${!NEEDED_HOSTS[@]}"; do
  echo "$IP     ${NEEDED_HOSTS[$IP]}" >> /etc/hosts
done

# Clone the repo
print_section "Repo cloning"
git clone $HEXA_HTTPS_LINK
#git clone $HEXA_SSH_LINK
mv $REPO_NAME /root/
cd /root/$REPO_NAME

# Prepare ansible
print_section "Ansible preparation"
echo "Do not forget to use your own config.yml in Hexa directory"
read -p "Press any key when you are ready"
echo "[defaults]"                                          >  /root/.ansible.cfg
echo "inventory  = /root/$REPO_NAME/$HOSTS_FILE"           >> /root/.ansible.cfg
echo "roles_path = /root/$REPO_NAME/roles"                 >> /root/.ansible.cfg
echo "forks      = $FORKS"                                 >> /root/.ansible.cfg

print_section "Call ansible first_start script"
ansible-playbook playbooks/first_start/first_start.yml