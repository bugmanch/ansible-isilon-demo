# Ansible Modules for Powersale demo

**By:** Thomas Bettems #Iwork4Dell

---

## Purpose

This is a repository of Ansible playbooks which aims to demonstrate the utilization of Ansible for orchestrating and automating Dell Powerscale NAS scale-out system.


### Configure Base Cluster
Sets all base settings for a Powerscale cluster. I use it when I need to rebuild my lab:

- Enables Source Base Routing
- Configure external network (groupnet, subnet, Management ippool)
- Configure NTP sources
- Joins Active Directory
- Creates a local NAS_Admin group, then create a custom Administrator role for that group.

Currently, Ansible for Powerscale is not able to include a group in a local group, so we can't add the Domain Admins group to the local administrator group, for instance. This must still be done manually.


### Configure Access Zones
This playbook demonstrates creation & configuration of a new Access Zone as I would recommend it:

- Create the Access Zone
- Create the associated IP Pool
- Adds domain administrators to the Local Administrator group
- Defines an Accounting Quota at the root of the new Access Zone. A hard quota can be optionnally specified.
- Creates an administrative c$ SMB share at the root of the Access Zone. Storage Admins should use this share for defining their root ACL permissions, and create user shares for the Access Zone.
- Optionnally, create a Snapshot Schedule for the Access Zone
- Optionnally, create a SyncIQ replication for the Access Zone 
- Create DNS dleegations for Smartconnect on a Windows DNS server

## Prerequisites

### 1. Powerscale: enable HTTP Basic Auth

HTTP Basic Auth must be enabled on your target Powerscale cluster. This is disabled on later releases of OneFS

```bash
isi_gconfig -t web-config auth_basic=true
```

More infos available on https://developer.dell.com/apis/4088/versions/9.7.0/docs/Getting%20Started/3make_your_first_call.md


### 2. Windows DNS server: enable HTTPS WinRM

On your Windows DNS server, define a winrm HTTPS listener:

```powershell
# Create self signed certificate
$certParams = @{
    CertStoreLocation = 'Cert:\LocalMachine\My'
    DnsName           = $env:COMPUTERNAME
    NotAfter          = (Get-Date).AddYears(1)
    Provider          = 'Microsoft Software Key Storage Provider'
    Subject           = "CN=$env:COMPUTERNAME"
}
$cert = New-SelfSignedCertificate @certParams

# Create HTTPS listener
$httpsParams = @{
    ResourceURI = 'winrm/config/listener'
    SelectorSet = @{
        Transport = "HTTPS"
        Address   = "*"
    }
    ValueSet = @{
        CertificateThumbprint = $cert.Thumbprint
        Enabled               = $true
    }
}
New-WSManInstance @httpsParams

# Opens port 5986 for all profiles
$firewallParams = @{
    Action      = 'Allow'
    Description = 'Inbound rule for Windows Remote Management via WS-Management. [TCP 5986]'
    Direction   = 'Inbound'
    DisplayName = 'Windows Remote Management (HTTPS-In)'
    LocalPort   = 5986
    Profile     = 'Any'
    Protocol    = 'TCP'
}
New-NetFirewallRule @firewallParams
```

Ansible procedure: https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html


### 3. Install Ansible prerequisites

Dell Github for Ansible Powerscale: [https://github.com/dell/ansible-powerscale](https://github.com/dell/ansible-powerscale)

1. Install Isilon Python SDK:

```bash
pip3 install isilon-sdk
```

2. Install Powerscale Ansible collection with following command-line:

```bash
ansible-galaxy collection install dellemc.powerscale
```

### 4. Customize hosts and variable files
Copy these files by removing the -example suffix, then customize them with your values and vaulted password:

- ./hosts
- ./vars/accesszones-example.yml
- ./vars/cluster-config-example.yml

See below on how to generate your vaulted password

## How to create a vaulted version of the password:

You can use the following one-liner:

```bash
echo -n "<Your_password> | ansible-vault encode_string
```

But maybe you'll prefer not having your password in your shell history. So you can encode your password interactively by using:

```bash
ansible-vault encrypt_string
```

**Caution:** After typing your password, type Ctrl+D immediately, without typing Enter! Otherwise, the Enter will be taken in consideration, and your password will not work...