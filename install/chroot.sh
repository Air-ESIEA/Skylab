#!/bin/bash
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime 
hwclock --systohc
sed -i 's/#en_US*/en_US/' /etc/locale.gen && locale-gen && printf 'LANG=en_US.UTF-8' > /etc/locale.conf 
echo 'Skylab' > /etc/hostname && printf '127.0.0.1 Skylab\n::1 Skylab\n10.0.2.15 air.esiea.fr' > /etc/hosts
pacman -S --noconfirm grub intel-ucode
systemctl start sshd && systemctl enable sshd
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
#source ../service/services.sh
