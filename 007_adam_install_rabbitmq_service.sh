#!/bin/bash 
# you might get this error when running as root user with sudo 
## root is not in the sudoers file.  This incident will be reported.

echo "RabbitMQ installation"
#update packages
yum -y update 


echo "installing epel-release "
yum install -y epel-release
yum -y update

echo "elang package"

cd /tmp/
wget http://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
yum install -y erlang

echo "RabbitMQ 3.6.1 package"

cd /tmp/
wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.1/rabbitmq-server-3.6.1-1.noarch.rpm
rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
yum install -y rabbitmq-server-3.6.1-1.noarch.rpm

echo "Start the RabbitMQ server and enable it to start on system boot"
systemctl start rabbitmq-server.service
systemctl enable rabbitmq-server.service

echo "You can check the status of RabbitMQ with:"
rabbitmqctl status

echo "rabbitMQ installation completed..."