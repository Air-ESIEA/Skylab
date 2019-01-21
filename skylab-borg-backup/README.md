# skylab-borg-backup
Automated backup scripts using Borg Backup, systemd and optionally Nextcloud/ownCloud/STACK.

This will backup the source files and folders of your choice to a repository of your choice and optionally synchronize the repository with one of your Nextcloud storage location.
You can (and should) run it daily and for now it will keep 7 daily, 4 weekly, 12 monthly and unlimited yearly archives of your source files.

# Installation

1. Install `borg` on your system
1. Copy `skylab-borg-backup.conf` to folder `/etc`.
   > **This should only be done the first time**
1. Copy `skylab-borg-backup.service`, `skylab-borg-backup.timer` and `unit-status-mail@.service` to folder `/etc/systemd/system`.
1. Copy `skylab-borg-backup` and `unit-status-mail` to folder `/usr/bin`

# Configuration
File `/etc/skylab-borg-backup.conf` contains all configuration options of the backup script.
The file is rather self-explanatory, but here are some hints:
* At least `REPOSITORY` and `SOURCES` should be defined.
* To prevent manual intervention for filling in your repository password interactively, you can define `BORG_PASSPHRASE`.

Of course, prior to using `skylab-borg-backup` for the `REPOSITORY` as defined in `/etc/skylab-borg-backup.conf`, you should setup the repository by i.e.:
borg init -e keyfile <repository>

## Running every night at 04:00
To run the script every night at 04:00, you can enable and start the related timer by:

systemctl enable skylab-borg-backup.timer
systemctl start skylab-borg-backup.timer
