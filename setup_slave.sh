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
echo 'configuring: adding environmental variables'
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

echo 'configuring: spark'
cp /opt/spark/conf/log4j.properties.template /opt/spark/conf/log4j.properties
sed -i '19s/.*/log4j.rootCategory=ERROR, console/' /opt/spark/conf/log4j.properties
cp /opt/spark/conf/spark-defaults.conf.template /opt/spark/conf/spark-defaults.conf
echo 'spark.driver.memory                5g' >> /opt/spark/conf/spark-defaults.conf
echo 'spark.executor.memory              5g' >> /opt/spark/conf/spark-defaults.conf
echo 'spark.sql.warehouse.dir         /home/ec2-user' >> /opt/spark/conf/spark-defaults.conf
echo 'spark.driver.extraJavaOptions -Dderby.system.home=/home/ec2-user' >> /opt/spark/conf/spark-defaults.conf

echo 'cleanup'
rm -f spark-2.2.0-bin-hadoop2.7.tgz
rm -f jdk-8u141-linux-x64.rpm