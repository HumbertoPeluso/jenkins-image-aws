#!/bin/bash
waitProcess () {
   echo 'waiting process to finish'
   while [[ `pgrep yum` -gt 0 ]]
    do
     sleep 5;
    done
}
echo "############ Intall Java ##############"
yum upgrade
waitProcess
yum update -y
waitProcess
yum -y update ca-certificates
waitProcesss

amazon-linux-extras install java-openjdk11
waitProcesss

echo "################## Install Docker engine #################"
yum install docker -y
waitProcesss
usermod -aG docker ec2-user
systemctl enable docker
waitProcesss

echo "Install git"
yum install -y git