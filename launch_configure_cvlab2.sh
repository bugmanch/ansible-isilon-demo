#!/bin/sh

ansible-playbook -vv --vault-password-file vlab_vault_passwd.txt -e @vars/cluster-config-cvlab2.yml ./configure_base_cluster.yml