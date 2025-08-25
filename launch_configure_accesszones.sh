#!/bin/sh

ansible-playbook -vv --vault-password-file vlab_vault_passwd.txt -e @vars/cluster-config-cvlab2.yml -e @vars/accesszones-cvlab2.yml -i hosts ./configure_access_zones.yml