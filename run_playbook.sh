#!/usr/bin/env bash

pacmatic -Syu
yay -Syu

ansible-playbook -K -i $1_inv.yml $1.yml
