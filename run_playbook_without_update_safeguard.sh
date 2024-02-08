#!/usr/bin/env bash

playbook=$(hostnamectl hostname)
if [[ -n "$1" ]] ; then
    playbook="$1"
fi

echo "running playbook $playbook"
echo ""

echo -n sudo Password: 
read -sr szPassword
echo ""
echo ""

echo "ATTENTION: not running system update safeguard"

vault_var_file="$playbook"_inv_v.yml
if [ -f "$vault_var_file" ]; then
  ./validate_vault_pass_file.sh || exit 1
  echo "using vault extra var file"
  ansible-playbook -i "$playbook"_inv.yml "$playbook.yml" --extra-vars "ansible_become_password=$szPassword" --extra-vars @"$vault_var_file" --vault-password-file .vault_pass
else
  ansible-playbook -i "$playbook"_inv.yml "$playbook.yml" --extra-vars "ansible_become_password=$szPassword"
fi
