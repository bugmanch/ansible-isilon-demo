#!/bin/sh

ansible-playbook -vv --vault-password-file vlab_vault_passwd.txt -e @vars/vlab-isilona.yml -e @vars/vlab-az-finance.yml ./configure_access_zones.yml