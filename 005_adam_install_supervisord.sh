#!/bin/bash 
# you might get this error when running as root user with sudo 
## root is not in the sudoers file.  This incident will be reported.


#update packages
yum -y update 

echo "install Supervisord service"
yum install -y supervisor 

echo "start supervisor service and check status"
service supervisord start
service supervisord status

echo "installation completed..."