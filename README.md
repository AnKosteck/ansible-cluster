# ansible-cluster
*ansible-cluster* is a collection of various [Ansible](https://www.ansible.com/) roles pursuing the goal of an easy (HPC) cluster deployment. *ansible-cluster* does this by leveraging many open source technologies. A few are mentioned below:
- [Ansible](https://www.ansible.com/) well, *ansible-cluster* is based on Ansible
- [Apache](http://httpd.apache.org/) as the webserver
- [Cobbler](http://cobbler.github.io/) as the install PXE server
- [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) as the DHCP/DNS server for cluster nodes
- [Slurm](https://www.schedmd.com/) as the resource manager for the cluster

**Disclaimer** the docu is out of sync at the moment since the configuration has shifted towards default values and system variable loading

## Idea of ansible-cluster
The idea behind *ansible-cluster* is that all relevant customizations and settings are done upfront and any command for handling a cluster operation happens via *Ansible* commands or applying some playbook, i.e. operating a (HPC) cluster is done in the *Ansible* context.

This means that the deployment of a (HPC) cluster should become as easy as
```
ansible-playbooks playbooks/clustersetup.yml
```

All an admin needs to customize or supply are the `example` and `template` files in the [samples](samples/) folder.

## What does *ansible-cluster* do?
There are several roles implemented in this repository and some are external. A more detailed description is given in the [roles](roles/) section. *ansible-cluster* *ansible-cluster* is planned to support a RHEL 7.X based server as a frontend with maybe additional servers for storage. The compute and login nodes can be installed with Ubuntu (16.04), RHEL 7.X based distributions or Fedora (last known working Fedora was 24). Please have a look at the [main config](config_template.yml).

## How to start off
To use *ansible-cluster* you need a RHEL/CentOS 7.X based system. Just grab any _x86 64bit able_ system since *ansible-cluster* itself does not have heavy requirements. Slurm is a different matter though since a fast storage may be of interest.

Then grab [first_start.sh](https://github.com/AnKosteck/ansible-cluster/blob/master/first_start.sh) from the *ansible-cluster* repository and change a few variables:
```bash
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
```
supply your own configurations (please look at the [samples](samples/)) and execute the script via `./first_start.sh`
This script sets up Ansible and Git, then clones the *ansible-cluster* Repository and finishes off by calling 
```
ansible-playbook playbooks/first_start/first_start.yml
```
From then on, the cluster can be managed with Ansible and *ansible-cluster*.
[first_start.yml](https://github.com/AnKosteck/ansible-cluster/blob/master/playbooks/first_start/first_start.yml) sets up a second interface for internal services (PXE, DHCP, ...) and disables SELinux. After the frontend hast been restarted, *ansible-cluster* should be usable.

## Templates and examples
In the [samples](samples/) folder examples and templates are given for you to start with.

