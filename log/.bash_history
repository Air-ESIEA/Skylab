ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime 
hwclock --systohc
vim /etc/locale.gen && locale-gen && vim /etc/locale.conf
cat 'Skylab' > /etc/hostname && echo '127.0.0.1 Skylab::1 Skylab127.0.1.1 air.esiea.fr' > /etc/hosts 
echo 'Skylab' > /etc/hostname && echo '127.0.0.1 Skylab::1 Skylab127.0.1.1 air.esiea.fr' > /etc/hosts
passwd && pacman -S grub intel-ucode
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
