#!/bin/bash 
# you might get this error when running as root user with sudo 
## root is not in the sudoers file.  This incident will be reported.


#update packages
yum -y update 

echo "install epel release package if not exist, re-run will not install package again."
yum install -y epel-release 
yum -y update

echo "installing Redis server"
yum install -y redis 

echo "Start redis server"
service redis start
echo "check status of redis server"
service redis status

echo "Installation completed..."