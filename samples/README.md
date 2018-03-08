# The samples
In this folder some examples and templates are given. What is shown here is actually, what _you_ would need to supply for Hexa to work.

## The environment
The [first start script](../first_start.sh) already sets the needed environment variables which are listed below
- HEXA_ACCOUNTING
- HEXA_CONFIG
- HEXA_GROUPS
- HEXA_PARTITIONS
- HEXA_SSH_LIMITS
- HEXA_USERS

Those variables should point to _your_ own configurations, which are explained below.

## The Ansible or Hexa inventory
In order to use *Hexa* some host variables and host groups need to be defined. In [`hexa_hosts_example`](hexa_hosts_example) some examples are shown. Instead of having all of the variables in a single file, the inventory can be split up into many files. Please take a look at the official ['Ansible documentation'](http://docs.ansible.com/ansible/latest/intro_inventory.html#splitting-out-host-and-group-specific-data) on the inventory.

## Examples and Templates
### config_template.yml
`config_template.yml` represents the main configuration file, meaning this is where most of the variables for the *Hexa* cluster are defined. In [`config_template.yml`](config_template.yml) all needed and used variables can be seen with example settings.
### groups_example.yml
In `groups_example.yml` all groups for user accounts can be defined, a few examples are shown in [`groups_example.yml`](groups_example.yml). Those groups can be deployed via
```
ansible-playbook playbooks/sync_users.yml
```
Please have a look at [usertool](https://github.com/AnKosteck/usertool) which can generate such files.

### partition_config_example.yml
In `partition_config_example.yml` are the partitions of a Slurm cluster defined, have a look at [`partition_config_example.yml`](partition_config_example.yml) for examples.
### slurm_accounts_example.yml
*Hexa* uses accouting in Slurm to restrict accesses to cluster nodes. For that, some accounts have to be created in Slurm. Examples are shown in [`slurm_accounts_example.yml`](slurm_accounts_example.yml) and can be added to the Slurm cluster via 
```
ansible-playbook playbooks/slurm_accounting.yml
```
### ssh_access_limits_example.yml
These Ansible variables are used in the [common](https://github.com/AnKosteck/Hexa/tree/master/roles/common) role inside the [limit_ssh.yml](https://github.com/AnKosteck/Hexa/blob/master/roles/common/tasks/limit_ssh.yml) play. Any cluster node being defined here is automatically restricted to the following
```
AllowUsers {{ssh_anywhere}} {{ssh_access_limits[ansible_hostname]}}
```
So this play essentially sets the `AllowUsers` line in the sshd_config of a system.
### users_example.yml
In `users_example.yml` all user accounts eligible for using the cluster are defined, a few examples analogue to the groups are shown in [`users_example.yml`](users_example.yml). Those users can be deployed via
```
ansible-playbook playbooks/sync_users.yml
```
and please have a look at [usertool](https://github.com/AnKosteck/usertool) which can generate such files.

