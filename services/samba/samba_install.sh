pacman -S --noconfirm samba
wget https://raw.githubusercontent.com/Air-ESIEA/Skylab/master/services/samba/smb.conf.default -O /etc/samba/smb.conf.default
cp /etc/samba/smb.conf{.default,}
mkdir -p /shares/AirESIEA01
groupadd -r sambausers
mkdir -p /shares/share01
chown -R root:sambausers /shares/AirESIEA01
sudo chmod -R 770 /shares/AirESIEA01
chmod 1770 /shares/AirESIEA01

# #Add userX to the sambausers group
# useradd -g sambausers userX
#
# #create new password for user userX
# smbpasswd -a userX
