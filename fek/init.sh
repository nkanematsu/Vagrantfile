#!/bin/sh

# mount
sudo /etc/init.d/vboxadd setup

# SELinux
sudo sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config


