#!/bin/bash 
# you might get this error when running as root user with sudo 
## root is not in the sudoers file.  This incident will be reported.


#update packages
yum -y update 


echo "installing epel release package"

rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y update 

echo "install nodejs"

curl -sL https://rpm.nodesource.com/setup_10.x | bash -
yum install -y nodejs

echo "check NodeJs and Npm version"
# if you see proper version output then it is properly installed
## Sample output: 
## v10.21.0
## 6.14.4

node -v && npm -v

echo "Installation completed..."