#!/usr/bin/env bash

echo -n sudo Password: 
read -s szPassword

echo $szPassword | sudo -S pacmatic -Syu
echo $szPassword | sudo -S yay -Syu

echo $szPassword | sudo -S ansible-playbook -i $1_inv.yml $1.yml --extra-vars "ansible_become_password=$szPassword"
