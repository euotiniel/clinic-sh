#!/bin/bash

source ../config.sh

echo "Script do Nfs - SERVER"

cd $PROJECT_URL

sudo mkdir -p $PWD_SERVER

sudo chown -R nobody:nogroup $PWD_SERVER

sudo chmod 777 $PWD_SERVER

echo '$PWD_SERVER IP_NETWORK + MASCARA(rw, sync, no_subtree_check)' >> /etc/exports

exportfs -ra
systemctl restart nfs-kernel-server
