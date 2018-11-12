pacman -S --noconfirm samba
wget https://raw.githubusercontent.com/Air-ESIEA/Skylab/master/services/samba/smb.conf.default -O /etc/samba/smb.conf.default
cp /etc/samba/smb.conf{.default,}
