# Hexa
*Hexa* leverages many open source technologies, a few are mentioned below:
- [Ansible](https://www.ansible.com/) well, *Hexa* is based on Ansible
- [Apache](http://httpd.apache.org/) as the webserver
- [Cobbler](http://cobbler.github.io/) as the install PXE server
- [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) as the DHCP/DNS server for cluster nodes
- [Slurm](https://www.schedmd.com/) as the resource manager for the cluster


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

Then grab [first_start.sh](https://github.com/AnKosteck/Hexa/blob/master/first_start.sh) from the *Hexa* repository, change a few variables:
```bash
declare -A NEEDED_HOSTS=(["192.168.1.254"]="$(hostname) $(hostname -f) $(hostname -s)" ["192.168.1.15"]="needed_host_X")
HEXA_HTTPS_LINK="https://github.com/AnKosteck/Hexa.git"
#HEXA_SSH_LINK="git@github.com:AnKosteck/Hexa.git"
REPO_NAME="Hexa"
HOSTS_FILE="hexa_hosts_example"
FORKS="5"

HEXA_ACCOUNTING="/root/Hexa/samples/slurm_accounts_example.yml"
HEXA_CONFIG="/root/Hexa/samples/config_template.yml"
HEXA_GROUPS="/root/Hexa/samples/groups_example.yml"
HEXA_PARTITIONS="/root/Hexa/samples/partition_config_example.yml"
HEXA_SSH_LIMITS="/root/Hexa/samples/ssh_access_limits_example.yml"
HEXA_USERS="/root/Hexa/samples/users_example.yml"
```
supply your own [config.yml](config_template.yml) and execute the script via `./first_start.sh`
This script sets up Ansible and Git, then clones the Hexa Repository and finishes off by calling 
```
ansible-playbook playbooks/first_start/first_start.yml
```
From then on, the cluster can be managed with Ansible and *Hexa*.
[first_start.yml](https://github.com/AnKosteck/Hexa/blob/master/playbooks/first_start/first_start.yml) sets up a second interface for internal services (PXE, DHCP, ...) and disables SELinux (in future *Hexa* should work with SELinux). After the frontend hast been restarted, *Hexa* should be usable.

## Templates and examples
In the [samples](samples/) folder examples and templates are given for you to start with.

