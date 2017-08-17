#!/bin/bash
echo 'downloading: java8 installer'
sudo wget "https://s3.amazonaws.com/moviematch/jdk-8u141-linux-x64.rpm"

echo 'installing: java8'
sudo rpm -ivh jdk-8u141-linux-x64.rpm

echo 'downloading: spark installer'
wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz

echo 'installing: spark'
sudo tar zxvf spark-2.2.0-bin-hadoop2.7.tgz -C /opt
sudo ln -fs spark-2.2.0-bin-hadoop2.7 /opt/spark

echo 'configuring: spark'
cp /opt/spark/conf/log4j.properties.template /opt/spark/conf/log4j.properties
sed -i '19s/.*/log4j.rootCategory=ERROR, console/' /opt/spark/conf/log4j.properties
cp /opt/spark/conf/spark-defaults.conf.template /opt/spark/conf/spark-defaults.conf
echo 'spark.driver.memory                7g' >> /opt/spark/conf/spark-defaults.conf
echo 'spark.executor.memory              7g' >> /opt/spark/conf/spark-defaults.conf
echo 'spark.sql.warehouse.dir         /home/ec2-user' >> /opt/spark/conf/spark-defaults.conf
echo 'spark.driver.extraJavaOptions -Dderby.system.home=/home/ec2-user' >> /opt/spark/conf/spark-defaults.conf

echo 'configuring: spark environmental variables'
echo 'export SPARK_HOME=/opt/spark' >> .bash_profile
echo 'PATH=$PATH:$SPARK_HOME/bin' >> .bash_profile
echo 'export PATH' >> .bash_profile
echo 'export JAVA_HOME=/usr/java/default' >> .bash_profile
echo 'export PYSPARK_PYTHON=python2.7' >> .bash_profile

echo 'installing: nodejs'
sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_8.x | sudo -E bash -
sudo yum install -y nodejs

echo 'installing: mongodb'
echo "[mongodb-org-3.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.0/x86_64/
gpgcheck=0
enabled=1" | sudo tee -a /etc/yum.repos.d/mongodb-org-3.0.repo
sudo yum install -y mongodb-org

echo 'configuring: mongodb'
sudo chkconfig mongod on
echo '* soft nofile 64000
* hard nofile 64000
* soft nproc 64000
* hard nproc 64000' | sudo tee /etc/security/limits.d/90-mongodb.conf

echo 'installing: project dependencies'
sudo pip install pymongo
sudo pip install numpy
sudo yum install -y git

echo 'configuring: operating system'
echo '*       soft  nofile  64000' | sudo tee -a /etc/security/limits.conf
echo '*       hard  nofile  64000' | sudo tee -a /etc/security/limits.conf
echo '*       hard  nproc  64000' | sudo tee -a /etc/security/limits.conf
echo '*       hard  nproc  64000' | sudo tee -a /etc/security/limits.conf
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to 8080
sudo service iptables save

echo 'starting: mongodb'
sudo service mongod start

echo 'cleaning'
rm -f spark-2.2.0-bin-hadoop2.7.tgz
rm -f jdk-8u141-linux-x64.rpm