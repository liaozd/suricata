#!/usr/bin/env bash

# install for "drive"
# https://github.com/odeke-em/drive/blob/master/platform_packages.md
sudo add-apt-repository ppa:twodopeshaggy/drive
sudo apt-get update
sudo apt-get install drive

# install for grive
sudo apt-add-repository ppa:thefanclub/grive-tools
sudo apt-get update
sudo apt-get install -y grive-tools