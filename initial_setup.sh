#!/usr/bin/env bash

# install software required to run ansible
pacman -Syu
pacman -S vim ansible git screen tree man go base-devel grub efibootmgr netctl dhcpcd

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

# install grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
