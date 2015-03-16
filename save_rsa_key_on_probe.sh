#!/bin/bash
# deploy collector server ssh key in the client
# so don't need to input password when ssh/scp

SERVER="collector.net" #server hostname
USER="azureuser" #login user name

cd ~/.ssh
scp -o "StrictHostKeyChecking no" $USER@$SERVER:.ssh/id_rsa collector.rsa
chmod 600 collector.rsa
echo "\n#probe data collector\n" >> config
echo "Host collector" >> config
echo "  Hostname $SERVER" >> config
echo "  User $USER" >> config
echo "  StrictHostKeyChecking no" >> config 
echo "  UserKnownHostsFile=/dev/null" >> config 
echo "  IdentityFile ~/.ssh/collector.rsa" >> config 

cowsay "you can directly ssh collector"
