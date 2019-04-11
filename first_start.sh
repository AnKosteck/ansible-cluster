#!/bin/bash

###
### first_start.sh
### Use this script to set up the basic system
###

function print_section() {
  echo ""
  echo "################ [$1]"
}

#**************************************************************************************************
#*** Setting facts
#TODO Set your own facts, execute as root

declare -A NEEDED_HOSTS=(["192.168.1.254"]="$(hostname) $(hostname -f) $(hostname -s)" ["192.168.1.15"]="needed_host_X")
REPO_HTTPS_LINK="https://github.com/AnKosteck/ansible-cluster.git"
#REPO_SSH_LINK="git@github.com:AnKosteck/ansible-cluster.git"
REPO_NAME="ansible-cluster"
HOSTS_FILE="cluster_hosts_example"
FORKS="5"

CLUSTER_ACCOUNTING="/root/ansible-cluster/samples/slurm_accounts_example.yml"
CLUSTER_CONFIG="/root/ansible-cluster/samples/config_template.yml"
CLUSTER_GROUPS="/root/ansible-cluster/samples/groups_example.yml"
CLUSTER_PARTITIONS="/root/ansible-cluster/samples/partition_config_example.yml"
CLUSTER_SSH_LIMITS="/root/ansible-cluster/samples/ssh_access_limits_example.yml"
CLUSTER_USERS="/root/ansible-cluster/samples/users_example.yml"
CLUSTER_WEBSITE="/root/ansible-cluster/website_example"
CLUSTER_MUNGE_KEY="/root/ansible-cluster/samples/munge.key"

#**************************************************************************************************

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
git clone --recursive $REPO_HTTPS_LINK
#git clone $REPO_SSH_LINK
mv $REPO_NAME /root/
cd /root/$REPO_NAME

# Prepare ansible
print_section "Ansible preparation"
echo "Do not forget to use your own config.yml in ansible-cluster directory"
read -p "Press any key when you are ready"
echo "[defaults]"                                          >  /root/.ansible.cfg
echo "inventory  = /root/$REPO_NAME/$HOSTS_FILE"           >> /root/.ansible.cfg
echo "roles_path = /root/$REPO_NAME/roles"                 >> /root/.ansible.cfg
echo "forks      = $FORKS"                                 >> /root/.ansible.cfg

print_section "Environment"
echo "CLUSTER_ACCOUNTING=\"$CLUSTER_ACCOUNTING\""   >> /root/.bash_profile
echo "CLUSTER_CONFIG=\"$CLUSTER_CONFIG\""           >> /root/.bash_profile
echo "CLUSTER_GROUPS=\"$CLUSTER_GROUPS\""           >> /root/.bash_profile
echo "CLUSTER_PARTITIONS=\"$CLUSTER_PARTITIONS\""   >> /root/.bash_profile
echo "CLUSTER_SSH_LIMITS=\"$CLUSTER_SSH_LIMITS\""   >> /root/.bash_profile
echo "CLUSTER_USERS=\"$CLUSTER_USERS\""             >> /root/.bash_profile
echo "CLUSTER_WEBSITE=\"$CLUSTER_WEBSITE\""         >> /root/.bash_profile
echo "CLUSTER_MUNGE_KEY=\"$CLUSTER_MUNGE_KEY\""     >> /root/.bash_profile
echo "" >> /root/.bash_profile
echo "export CLUSTER_ACCOUNTING"                 >> /root/.bash_profile
echo "export CLUSTER_CONFIG"                     >> /root/.bash_profile
echo "export CLUSTER_GROUPS"                     >> /root/.bash_profile
echo "export CLUSTER_PARTITIONS"                 >> /root/.bash_profile
echo "export CLUSTER_SSH_LIMITS"                 >> /root/.bash_profile
echo "export CLUSTER_USERS"                      >> /root/.bash_profile
echo "export CLUSTER_WEBSITE"                    >> /root/.bash_profile
echo "export CLUSTER_MUNGE_KEY"                  >> /root/.bash_profile
source /root/.bash_profile
echo "*** Do not forget to set your own variables, please look at /root/.bash_profile and then source that ***"

print_section "Generate users.digest"
mkdir -p /etc/cobbler
yum -y install httpd
echo "Input your password for the cobbler user for Cobbler Web"
htdigest -c /etc/cobbler/users.digest "Cobbler" cobbler

print_section "Call ansible first_start script"
ansible-playbook playbooks/first_start/first_start.yml

