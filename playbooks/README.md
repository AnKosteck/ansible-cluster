# The playbooks 
*Hexa* supplies some helpful playbooks to get startet. Here is more detailed information given. For each (important) role a playbook is given so that testing and setup can be faster.

## Playbooks for roles
For ease of use every role has its own playbook, so that from the root of *Hexa* a role can be deployed via
```
ansible-playbook playbooks/<ROLE-NAME>.yml
```

### frontend.yml and frontend_complete.yml
There are 2 playbooks for the frontend since a complete frontend will take way longer, mostly due to [cobbler_server](cobbler_server.yml). After *frontend.yml* all core functionalities are configured and set up. Missing although are the *Cobbler* bits, so another playbook for **cobbler**_**server** is included. The reason for **cobbler server** not being included in the basic *frontend.yml* is that the mirroring or syncing of official repositories may take really long.

### clustersetup.yml
Here all steps are included, starting with the *nfs server* setup and finishing of with software. This playbook requires an almost completely configured frontend and already provisioned nodes. The prerequired roles are [frontend.yml](frontend.yml) and [cobbler_server](cobbler_server) or alternatively just [frontend_complete.yml](frontend_complete.yml).

## Other playbooks
### reinstall_nodes.yml
This playbook was done so that every node except the frontend can be reinstalled using Cobbler via PXE (playbook is broken right now). This is most useful for debugging or testing.
### remove_cobbler_systems.yml
This playbook removes all known systems from Cobbler. This means that every node can be redone and is most useful for debbuging or testing.
### remove_guests_cobbler.yml
This playbook just removes the virtual machines.
### slurm_accounting.yml
This playbook is used for *Slurm* accounting management. The idea behind accounting for *Hexa* are limits of special queues to privileged users. The *Slurm* configuration is considered as unfinished as of now as is this playbook.
### sync_hosts.yml
This playbook syncs all hosts defined in the Ansible inventory with the Cobbler lists and additionally starts virtual machines on the frontend. In the future this playbook should be able to provision guests on any cluster node.
### sync_users.yml
This playbook represents the user management of *Hexa*. Any user or group defined in [users.yml](../users_example.yml) or [groups.yml](../groups_example.yml) will be added on every computing relevant node. Please look at [usertool](https://github.com/AnKosteck/usertool) which can create such files taking local users (passwd) on BSD or GNU/Linux systems.
### update.yml
With this playbook every node can be fully updated.
