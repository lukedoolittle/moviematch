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
export SPARK_HOME=/opt/spark
PATH=$PATH:$SPARK_HOME/bin
export PATH
export JAVA_HOME=/usr/java/default

echo 'configuration: spark'
cp $SPARK_HOME/conf/log4j.properties.template $SPARK_HOME/conf/log4j.properties
sed -i '19s/.*/log4j.rootCategory=ERROR, console/' $SPARK_HOME/conf/log4j.properties
cp $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf
echo 'spark.driver.memory                7g' >> $SPARK_HOME/conf/spark-defaults.conf
echo 'spark.executor.memory              7g' >> $SPARK_HOME/conf/spark-defaults.conf
echo 'spark.sql.warehouse.dir         /home/ec2-user' >> $SPARK_HOME/conf/spark-defaults.conf
echo 'spark.driver.extraJavaOptions -Dderby.system.home=/home/ec2-user' >> $SPARK_HOME/conf/spark-defaults.conf

echo 'installing: nodejs'
yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_8.x | bash -
yum install -y nodejs

echo 'installing: mongodb'
cat > /etc/yum.repos.d/mongodb-org-3.4.repo <<EOF
[mongodb-org-3.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc
EOF
yum install -y mongodb-org

# install mongodb python interface
pip install pymongo

# forward HTTP traffic to port 8080
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to 8080

# start services needed for this session
echo 'service mongod start' >> .bash_profile
service mongod start

# need to increase the maximum number of open files for
# larges instances
echo 'ulimit -n 64000' >> .bash_profile
ulimit -n 64000

echo 'cleanup'
rm spark-2.2.0-bin-hadoop2.7.tgz
rm jdk-8u141-linux-x64.rpm