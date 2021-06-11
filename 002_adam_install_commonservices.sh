#!/bin/bash 
# you might get this error when running as root user with sudo 
## root is not in the sudoers file.  This incident will be reported.


#update packages
yum -y update 


echo "Installing common packages like Git, wget, gcc & screen"
yum install -y git gcc wget screen

echo "Installation completed..."

