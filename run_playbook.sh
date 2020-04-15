#!/usr/bin/env bash

playbook=$(hostname)
if [[ ! -z "$1" ]] ; then
    playbook="$1"
fi

echo "running playbook $playbook"
echo ""

echo -n sudo Password: 
read -sr szPassword
echo ""

if echo "$szPassword" | sudo -S pacman -Syup | grep -q 'https';
then
  echo "!! system needs an upgreade"
  echo "please run:"
  echo "  sudo pacmatic -Syu && yay -Syu"
  exit 1
else
  echo "system up to date"
fi

echo "$szPassword" | sudo -S ansible-playbook -i "$1_inv.yml" "$1.yml" --extra-vars "ansible_become_password=$szPassword"
