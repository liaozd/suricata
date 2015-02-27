#!/bin/bash

uname -a
echo "must be run on the server side"

cd ~/.ssh
ssh-keygen -t rsa # hit return through prompts
cat id_rsa.pub >> authorized_keys
chmod 600 authorized_keys
