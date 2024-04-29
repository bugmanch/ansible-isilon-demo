#!/bin/sh

ansible-playbook -vvv --vault-password-file my_vault_passwd.txt ./test_collect.yml