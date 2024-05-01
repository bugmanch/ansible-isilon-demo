# Test Ansible Powersale

**By:** Thomas Bettems

---

## Purpose

This is a repository of Ansible playbooks which aims to demonstrat the utilization of Ansible for orchestrating and automating Dell Powerscale NAS scale-out system.

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
