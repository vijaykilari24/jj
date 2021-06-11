#!/bin/bash 
# you might get this error when running as root user with sudo 
## root is not in the sudoers file.  This incident will be reported.


#update packages
yum -y update 

echo "installing postgresql-devel package, required for python module psycopg2"
yum install -y postgresql-devel 

echo "installing openldap package, pre-requisites for python-ldap module" 
yum install -y openldap-devel 

echo "installation completed..."