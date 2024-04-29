#!/bin/sh

ansible-playbook -vvv --vault-password-file my_vault_passwd.txt ./configure_lab.yml