#!/bin/bash

# install the nfs package in order to share the nfs_volume

sudo mkdir /{mysql,html}
sudo chmod -R 755 /{mysql,html}
sudo chown nfsnobody:nfsnobody /{mysql,html}
sudo systemctl enable rpcbind ; sudo systemctl enable nfs-server
sudo systemctl enable nfs-lock ; sudo systemctl enable nfs-idmap
sudo systemctl start rpcbind ; sudo systemctl start nfs-server
sudo systemctl start nfs-lock ; sudo systemctl start nfs-idmap


# vi /etc/exportfs
/mysql  <nfs_ip>/24 or *(rw,sync,no_subtree_check,insecure)
/html  <nfs_ip>/24 or *(rw,sync,no_subtree_check,insecure)

# exportfs -v
