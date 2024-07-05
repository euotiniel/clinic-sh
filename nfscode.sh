#!/bin/bash/


echo "Script do Nfs - SERVER"

cd /
sudo mkdir -p /Teste_nfs0/nfs0

sudo chmod -R nobody:nogroup /Teste_nfs0/nfs0

sudo chmod 777 /Teste_nfs0/nfs0

echo '/Teste_nfs0/nfs0 IP_DA_REDE + MASCARA(rw, sync, no_subtree_check)' >> /etc/exports

exportfs -ra
systemctl restart nfs-kernel-server



echo "Script do NFS - CLIENTE"

cd /

sudo  mkdir -p /Nfs_share/file_share

sudo mount IP_DO_SERVER:/Teste_nfs0/nfs0 /Nfs_share/file_share
