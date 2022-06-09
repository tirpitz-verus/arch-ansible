#!/usr/bin/env bash

playbook=$(hostnamectl hostname)
if [[ -n "$1" ]] ; then
    playbook="$1"
fi

./validate_vault_pass_file.sh || exit 1

ansible-vault edit "$playbook"_inv_v.yml --vault-password-file .vault_pass