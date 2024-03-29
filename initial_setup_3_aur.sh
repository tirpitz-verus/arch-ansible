#!/usr/bin/env bash

# setup aur_builder user

if ! id -u aur_builder > /dev/null 2>&1
then
	useradd -m aur_builder
	SUDO_FILE=/etc/sudoers.d/11-install-aur_builder
	touch $SUDO_FILE
	echo "aur_builder ALL=(ALL:ALL) NOPASSWD: /usr/bin/pacman" >> $SUDO_FILE
	visudo -cf $SUDO_FILE

	sudo -i -u aur_builder bash << EOF
cd /home/aur_builder
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
yay -S --noconfirm ansible-aur-git
EOF
fi
