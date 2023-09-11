#!/bin/bash

waitProcess () {
   echo 'waiting process to finish'
   while [[ `pgrep yum` -gt 0 ]]
    do
     sleep 5;
    done
}

yum upgrade
waitProcess

echo "########### Installing Amazon Linux extras ##########"
waitProcess
amazon-linux-extras install epel -y
waitProcess
amazon-linux-extras install java-openjdk11
waitProcess

echo "##########Install Jenkins stable release##########"
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install -y jenkins
waitProcess
systemctl daemon-reload
chkconfig jenkins on

echo "########## Install git ##########"
yum install -y git
waitProcess

echo "########## Setup SSH key ##########"
mkdir -p /var/lib/jenkins/.ssh
touch /var/lib/jenkins/.ssh/known_hosts
chown -R jenkins:jenkins /var/lib/jenkins/.ssh
chmod 700 /var/lib/jenkins/.ssh
mv /tmp/id_rsa /var/lib/jenkins/.ssh/id_rsa
chmod 600 /var/lib/jenkins/.ssh/id_rsa
chown -R jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa

echo "########## Configure Jenkins ##########"
mkdir -p /var/lib/jenkins/init.groovy.d
mv /tmp/scripts/*.groovy /var/lib/jenkins/init.groovy.d/
chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d
mv /tmp/config/jenkins /etc/sysconfig/jenkins
chmod +x /tmp/config/install-plugins.sh
bash /tmp/config/install-plugins.sh
service jenkins start
