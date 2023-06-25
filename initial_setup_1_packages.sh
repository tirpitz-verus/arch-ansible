#!/usr/bin/env bash

# install and run dhcpcd

pacman -S dhcpcd

systemctl enable dhcpcd
systemctl start dhcpcd
