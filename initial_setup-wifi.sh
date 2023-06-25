#!/usr/bin/env bash

./initial_setup_1_packages.sh || exit 1

./initial_setup_2_dhcpcd.sh || exit 1

pacman -S iwd wpa_supplicant

./initial_setup_3_aur.sh || exit 1

./initial_setup_4_grub.sh || exit 1
