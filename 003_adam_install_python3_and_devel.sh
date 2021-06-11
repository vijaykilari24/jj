#!/bin/bash 
# you might get this error when running as root user with sudo 
## root is not in the sudoers file.  This incident will be reported.


#update packages
yum -y update 

###

echo "c package, python3-devel and setup-tools"
# please note python3-devel package is very important for the apps to get build properly
# so verify whether you have that package available with "search" command
# yum search python3-devel
# 
yum install -y python3 python3-devel.x86_64

echo "upgrading pip3 to latest"
pip3 install --upgrade pip

echo "install virtualenv "
pip3 install virtualenv

echo "Current python3 version"
python3 --version

echo "Installation completed..."