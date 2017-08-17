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

# add pyspark, spark-sql to path
echo 'configuration: adding environmental variables'
echo 'export SPARK_HOME=/opt/spark' >> .bash_profile
echo 'PATH=$PATH:$SPARK_HOME/bin' >> .bash_profile
echo 'export PATH' >> .bash_profile
echo 'export JAVA_HOME=/usr/java/default' >> .bash_profile
echo 'export PYSPARK_PYTHON=python2.7' >> .bash_profile
export SPARK_HOME=/opt/spark
PATH=$PATH:$SPARK_HOME/bin
export PATH
export JAVA_HOME=/usr/java/default
export PYSPARK_PYTHON=python2.7

echo 'configuration: spark'
cp /opt/spark/conf/log4j.properties.template /opt/spark/conf/log4j.properties
sed -i '19s/.*/log4j.rootCategory=ERROR, console/' /opt/spark/conf/log4j.properties
cp /opt/spark/conf/spark-defaults.conf.template /opt/spark/conf/spark-defaults.conf
echo 'spark.driver.memory                7g' >> /opt/spark/conf/spark-defaults.conf
echo 'spark.executor.memory              7g' >> /opt/spark/conf/spark-defaults.conf
echo 'spark.sql.warehouse.dir         /home/ec2-user' >> /opt/spark/conf/spark-defaults.conf
echo 'spark.driver.extraJavaOptions -Dderby.system.home=/home/ec2-user' >> /opt/spark/conf/spark-defaults.conf

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

# install necessary python packages
sudo pip install pymongo
sudo pip install numpy

# forward HTTP traffic to port 8080
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to 8080
echo 'iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to 8080' >> .bash_profile

# start services needed for this session
sudo chkconfig mongod on
sudo service mongod start
echo '* soft nofile 64000
* hard nofile 64000
* soft nproc 64000
* hard nproc 64000' | sudo tee /etc/security/limits.d/90-mongodb.conf

# need to increase the maximum number of open files for
# larges instances
echo '*       soft  nofile  64000' | sudo tee -a /etc/security/limits.conf
echo '*       hard  nofile  64000' | sudo tee -a /etc/security/limits.conf
echo '*       hard  nproc  64000' | sudo tee -a /etc/security/limits.conf
echo '*       hard  nproc  64000' | sudo tee -a /etc/security/limits.conf

sudo yum install -y git

echo 'cleanup'
rm -f spark-2.2.0-bin-hadoop2.7.tgz
rm -f jdk-8u141-linux-x64.rpm