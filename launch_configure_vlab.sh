#!/bin/sh

ansible-playbook -vv --vault-password-file vlab_vault_passwd.txt -e @vars/vlab-isilona.yml ./configure_base_cluster.yml