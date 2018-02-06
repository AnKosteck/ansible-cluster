# Hexa
*Hexa* leverages many open source technologies, a few are mentioned below:
- [Ansible](https://www.ansible.com/) well, *Hexa* is based on Ansible
- [Apache](http://httpd.apache.org/) as the webserver
- [Cobbler](http://cobbler.github.io/) as the install PXE server
- [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) as the DHCP/DNS server for cluster nodes
- [Slurm](https://www.schedmd.com/)


## Idea of Hexa
The idea behind *Hexa* is that all relevant customizations for a cluster are done upfront in the root of *Hexa* in some configuration files while the rest is set to sane or (almost) secure defaults.

This means that the deployment of a cluster becomes as easy as
```
ansible-playbooks playbooks/clustersetup.yml
```

All an admin needs to customize or supply are the `example` and `template` files.

## What does Hexa do?
There are several roles implemented in Hexa:
* [cobbler_server](https://github.com/AnKosteck/Hexa/tree/master/roles/cobbler_server)
* [common](https://github.com/AnKosteck/Hexa/tree/master/roles/common)
* [compute](https://github.com/AnKosteck/Hexa/tree/master/roles/compute)
* [frontend](https://github.com/AnKosteck/Hexa/tree/master/roles/frontend)
* [fs](https://github.com/AnKosteck/Hexa/tree/master/roles/fs)
* [gpu](https://github.com/AnKosteck/Hexa/tree/master/roles/gpu)
* [login](https://github.com/AnKosteck/Hexa/tree/master/roles/login)
* [mariadb](https://github.com/AnKosteck/Hexa/tree/master/roles/mariadb)
* [ntp_client](https://github.com/AnKosteck/Hexa/tree/master/roles/ntp_client)
* [software](https://github.com/AnKosteck/Hexa/tree/master/roles/software)
* [webserver](https://github.com/AnKosteck/Hexa/tree/master/roles/webserver)
* [webserver_system](https://github.com/AnKosteck/Hexa/tree/master/roles/webserver_system)

A more detailed description is given in this [README](roles/README.md). *Hexa* is planned to support a RHEL 7.X based server as a frontend with maybe additional servers for storage. The compute and login nodes can be installed with Ubuntu (16.04), RHEL 7.X based distributions or Fedora (last known working Fedora was 24). Please have a look at the [main config](config_template.yml).

## How to start off
To use *Hexa* you need a RHEL 7.X based system. Just grab any _x86 64bit able_ system, since *Hexa* has not heavy requirements. If a server can run a 64 bit RHEL 7.X system, it can run Hexa too. Slurm is a different matter though, a fast storage may be of interest.
Then grab [first_start.sh](https://github.com/AnKosteck/Hexa/blob/master/first_start.sh) from the *Hexa* repository and change a few variables:
```bash
declare -A NEEDED_HOSTS=(["192.168.1.254"]="$(hostname) $(hostname -f) $(hostname -s)" ["192.168.1.15"]="needed_host_X")
HEXA_HTTPS_LINK="https://github.com/AnKosteck/Hexa.git"
#HEXA_SSH_LINK="git@github.com:AnKosteck/Hexa.git"
REPO_NAME="Hexa"
HOSTS_FILE="hexa_hosts_example"
FORKS="5"
```
And execute the script `./first_start.sh`
This script sets up Ansible and Git, then clones the Hexa Repository and finishes off by calling 
```
ansible-playbook playbooks/first_start/first_start.yml
```
From then on, the cluster can be managed with Ansible and *Hexa*.
[first_start.yml](https://github.com/AnKosteck/Hexa/blob/master/playbooks/first_start/first_start.yml) sets up a second interface for internal services (PXE, DHCP, ...) and disables SELinux (in future *Hexa* should work with SELinux). After the frontend hast been restarted, *Hexa* should be usable.

## Templates and examples
### config_template.yml and config.yml
`config.yml` is the main configuration file, meaning it is here where most of the variables for the cluster or *Hexa* are defined. In [`config_template.yml`](config_template.yml) all needed and used variables can be seen with example settings.
### groups_example.yml and group.yml
In `groups.yml` all groups from user accounts can be defined, a few examples are shown in [`groups_example.yml`](groups_example.yml). Those groups can be deployed via
```
ansible-playbook playbooks/sync_users.yml
```
Please have a look at [usertool](https://github.com/AnKosteck/usertool) which can generate such files.
### hexa_hosts_example and the Ansible inventory
In order to use *Hexa* some host variables and host groups need to be defined. In [`hexa_hosts_example`](hexa_hosts_example) some examples are shown.
### partition_config_example.yml and partition_config.yml
In `partition_config.yml` are the partitions of a Slurm cluster defined, have a look at [`partition_config_example.yml`](partition_config_example.yml) for examples.
### slurm_accounts_example.yml and slurm_accounts.yml
*Hexa* uses accouting in Slurm to restrict accesses to cluster nodes. For that, some accounts have to be created in Slurm. Examples are shown in [`slurm_accounts_example.yml`](slurm_accounts_example.yml) and can be added to the Slurm cluster via 
```
ansible-playbook playbooks/slurm_accounting.yml
```
This playbook expects a `slurm_accounts.yml` in the *Hexa* root.
### ssh_access_limits_example.yml and ssh_access_limits.yml
These Ansible variables are used in the [common](https://github.com/AnKosteck/Hexa/tree/master/roles/common) role inside the [limit_ssh.yml](https://github.com/AnKosteck/Hexa/blob/master/roles/common/tasks/limit_ssh.yml) play. Any cluster node being defined here is automatically restricted to the following
```
AllowUsers {{ssh_anywhere}} {{ssh_access_limits[ansible_hostname]}}
```
So this play essentially sets the `AllowUsers` line in the sshd_config of a system.
### users_example.yml and users.yml
In `users.yml` all user accounts eligible for using the cluster are defined, a few examples analogue to the groups are shown in [`users_example.yml`](users_example.yml). Those users can be deployed via
```
ansible-playbook playbooks/sync_users.yml
```
and please have a look at [usertool](https://github.com/AnKosteck/usertool) which can generate such files.

