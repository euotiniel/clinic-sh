
#!/bin/bash/

source ../config.sh

echo "Script do NFS - CLIENTE"

cd $PROJECT_URL

sudo mount $IP_SERVER:$PWD_SERVER $PWD_CLIENT

# sudo  mkdir -p /Nfs_share/file_share
