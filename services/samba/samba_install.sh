pacman -S --noconfirm samba
wget https://raw.githubusercontent.com/Air-ESIEA/Skylab/master/services/samba/smb.conf.default -O /etc/samba/smb.conf.default
cp /etc/samba/smb.conf{.default,}
mkdir -p /shares/Air-ESIEA_share01
groupadd -r sambausers
chown -R root:sambausers /shares/Air-ESIEA_share01
chmod 1770 /shares/Air-ESIEA_share01

# #Add userX to the sambausers group
# sudo passwd sambausers -a userX
#
# #create new password for user userX
# sudo smbpasswd -a userX
