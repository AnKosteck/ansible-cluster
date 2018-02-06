# Roles
Descriptions of the roles going by their alphanumerical sorting.
## cobbler_server
This role consists of tasks only (no files, no templates). Since this role is applied to the frontend, a RHEL 7.X based OS is required. This are the tasks:
1. Repository management, according to the *cobbler_repos* in the main config file
  1.1 Create and add repositories
  1.2. reposync **BEWARE** this will take really long, dependending on your internet connection, the amount of repos and the servers you sync from
2. Distro management, according to the *distros* in the main config file
  2.1 First every iso will be downloaded
  2.2 From each iso this role will instruct cobbler to create basic distro installations and profiles via 
  ```
  cobbler import ...
  ```
3. Profile management: For each distro in the main config file an additional profile will be added / updated, named after `item.name` of each distro. Doing so allows for swapping out the underlying base distro. This is useful for, e.g. an incremental update to CentOS

## common
This role does tasks which may be *common* to every node in the cluster. This includes
- Installing packages which should be installed on any node
- Setting up the nfs_imports for the homes and apps
- Setting the ssh limitations, please look at the [ssh limits_examples](../ssh_access_limits_example.yml)
- Finally setting up the Infiniband interfaces (Mellanox) on supported nodes

These tasks require various files and templates, please take a look at them

## compute
The *compute* tasks first disables *firewalld* (since compute nodes should be localized anyways and firewalld may consume some ressources or block applications) and then installs [Ganglia](http://ganglia.sourceforge.net/) ( *gmond* only) from official repos (which are mirrored on the frontend).

## frontend
This role is the start for every cluster and sets up the management or *frontend* node. *Hexa* only supports RHEL 7.X based distributions. The frontend role includes of course many tasks:
1. At first the [epel](https://fedoraproject.org/wiki/EPEL) repository is set up on the frontend
2. Setting up *kvm* on the frontend (support for *kvm* is planned for any node) so that VM's may be set up on the frontend
  2.1 At first kvm is installed from the official repos
  2.2 Then the interfaces are bridged
3. The firewall daemon is configured. Se the rules in the [variables definitions](frontend/vars/firewallconf.yml) and the [task](frontend/tasks/firewall.yml)
4. [Cobbler](http://cobbler.github.io/) installation: Snippets, kickstart, scripts and other files are copied to the cobbler directories. Cobbler itself and all its components will be installed from official repositories. The actual Cobbler management is handled in the **cobbler server** role and the main config file
5. [Cockpit](http://cockpit-project.org/) will be installed from official repos, although this program is not (yet) used. In the future this may change.
6. The *frontend* acts as the **ntp server** for the whole cluster and gets thus set up
7. Finally *opensm* will be installed on the frontend, so that the *frontend* can act as the Infiniband (Mellanox) subnet manager

This role copies many files and templates, so please have a look at them.

## fs
This role does just 1 task, which is exporting the `nfs_export` variable via nfs. Please have a look at the [hosts examples](../hexa_hosts_example) and the [fs playbook](../playbooks/fs.yml)

## gpu
This role is planned to set up *GPGPU* related stuff, but as of now is unused and does nothing.

## login
In the *login* role those nodes with public access (ssh) should be set up. As of now, this role just copies the slurm configuration. In the future, the firewall daemon should be configured too.

## mariadb
For accounting in slurm mysql will be used. Hence the installation of [mariadb](https://mariadb.org/). For the configuration please look at the [main config](../config_template.yml)

## ntp_client
This role represents the counterpart to the **ntp server** task in the *frontend* role and does just that.

## software
Since not every software is available in repos or different versions may be harmful, some select software will be installed in a manual fashion.
1. First a build environment is set up. For this many development tools like gcc are installed on every node. For the build system 3 directories are used: `build_anchors` `install_scripts_dir` and `source_download_dir`. Please look at the [main config](../config_template.yml)
2. [Munge](https://dun.github.io/munge/) is the software part and is installed directly from official repositories. This is done here for the reason that any node needing the following software also will need **Munge** and thus the host selection for Ansible is the same.
3. [OpenMPI](https://www.open-mpi.org/) is installed via downloading and compiling. Please see the [installation script](software/templates/openmpi.sh) and the [main config](../config_template.yml)
4. [Slurm](https://www.schedmd.com/) is also installed via downloading and compiling. Please see the [installation script](software/templates/slurm.sh) and the [main config](../config_template.yml)

## webserver
*Hexa* supports the (basic) setup of a RHEL 7.X based website or webserver (in the future this role may be renamed to *website* ) with *Ganglia* ( *gmetad* this time) integration. The installation for Icinga as of now is not supported, some installation tasks are still being kept though. The **setup website** task supports self signed certificates and official certificates (you have to supply them yourself of course).

## webserver_system
This role handles the interfaces and firewall configuration on webservers. Since the frontend is configured in its own role, this should only be done to non-frontend nodes. For the firewall configuration please look at the [firewall task](webserver_system/tasks/firewall.yml) and the [variables](webserver_system/vars/main.yml)
