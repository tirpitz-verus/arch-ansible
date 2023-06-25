#!/usr/bin/env bash

./initial_setup_install_packages.sh || exit 1

pacman -S netctl iwd

./initial_setup_aur.sh || exit 1

./initial_setup_grub.sh || exit 1
