source bind/bind.sh
source dovecot/dovecot.sh
source postfix/postfix.sh
source httpd/httpd.sh
source iptables/iptables.sh
source samba/samba.sh
source gitea/gitea.sh


systemctl enable named.service
systemctl enable samba.service
systemctl enable httpd.service
systemctl enable iptables.service
systemctl enable postfix.service
systemctl enable dovecot.service
systemctl enable gitea.service
#systemctl enable 
