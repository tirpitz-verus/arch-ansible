#!/usr/bin/env bash

# install packages

pacman -Syu
pacman -S neovim ansible git screen tree man go base-devel dhcpcd

systemctl enable dhcpcd
systemctl start dhcpcd