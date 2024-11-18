# Ansible Modules for Powersale demo

**By:** Thomas Bettems

---

## Purpose

This is a repository of Ansible playbooks which aims to demonstrate the utilization of Ansible for orchestrating and automating Dell Powerscale NAS scale-out system.



### Configure Base Cluster
Sets all base settings for a Powerscale cluster. I use it when I need to rebuild my lab:

- Enables Source Base Routing
- Configure external network (groupnet, subnet, Management ippool)
- Configure NTP sources
- Joins Active Directory


### Configue Access Zones
This playbook demonstrates creation & configuration of a new Access Zone as I would recommend it:

- Create the Access Zone
- Create the associated IP Pool
- Adds domain administrators to the Local Administrator group
- Defines an Accounting Quota at the root of the new Access Zone. A hard quota can be optionnally specified.
- Creates an administrative c$ SMB share at the root of the Access Zone. Storage Admins should use this share for defining their root ACL permissions, and create user shares for the Access Zone.
- Optionnally, create a Snapshot Schedule for the Access Zone
- Optionnally, create a SyncIQ replication for the Access Zone 

## Prerequisites

### HTTP Basic Auth

HTTP Basic Auth must be enabled on your target Powerscale cluster. This is disabled on later releases of OneFS

`isi_gconfig -t web-config auth_basic=true`

More infos available on https://developer.dell.com/apis/4088/versions/9.7.0/docs/Getting%20Started/3make_your_first_call.md

## Sources

Dell Github for Ansible Powerscale: [https://github.com/dell/ansible-powerscale](https://github.com/dell/ansible-powerscale)

1. Install Isilon Python SDK:

`pip3 install isilon-sdk`

2. Install Powerscale Ansible collection with following command-line:

`ansible-galaxy collection install dellemc.powerscale`


## How to create a vaulted version of the password:

You can use the following one-liner:

```bash
echo -n "<Your_password> | ansible-vault encode_string
```

But maybe you'll prefer not having your password in your shell history. So you can encode your password interactively by using:

```bash
ansible-vault encode_string
```

**Caution:** After typing your password, type Ctrl+D immediately, without typing Enter! Otherwise, the Enter will be taken in consideration, and your password will not work...
