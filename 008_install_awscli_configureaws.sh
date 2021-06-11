#!/bin/bash 
# you might get this error when running as root user with sudo 
## root is not in the sudoers file.  This incident will be reported.


#update packages
yum -y update 

echo "installing awscli module"
pip3 install awscli

echo "Configure awscli with IAM credentails provided by JNJ team"

aws configure
#AWS Access Key ID: <ENTER ACCESSKEYID>
#AWS Secret Access Key: <ENTER SECERT KEY>
#region name: <S3 BUCKETS LOCATED REGION_NAME>
#output format: json