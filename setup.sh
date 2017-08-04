#!/bin/bash
# create the data directory to work from
mkdir data
chmod a+rwx /data

# run the UCB setup script which installs Hadoop, Postgres, and Hive
read -p 'Please enter the location of your attached volume [default is xvdb]: /dev/' locationvar
locationvar=${locationvar:-xvdb}
echo 'running: UCB complete setup script'
wget https://s3.amazonaws.com/ucbdatasciencew205/setup_ucb_complete_plus_postgres.sh
chmod +x ./setup_ucb_complete_plus_postgres.sh
./setup_ucb_complete_plus_postgres.sh /dev/$locationvar

echo 'running: UCB spark setup script'
wget https://s3.amazonaws.com/ucbdatasciencew205/setup_spark.sh
bash ./setup_spark.sh

# add pyspark, spark-sql to path for w205 and root
# and change the pyspark interpreter to use python 2.6
echo 'configuration: adding environmental variables for spark'
echo 'export SPARK=/data/spark15' >>/home/w205/.bash_profile
echo 'export SPARK=/data/spark15' >>.bash_profile
echo 'export SPARK_HOME=$SPARK' >>/home/w205/.bash_profile
echo 'export SPARK_HOME=$SPARK' >>.bash_profile
echo 'export PATH=$SPARK/bin:$PATH' >>/home/w205/.bash_profile
echo 'export PATH=$SPARK/bin:$PATH' >>.bash_profile
echo 'export PYSPARK_PYTHON=python2.6' >>/home/w205/.bash_profile
echo 'export PYSPARK_PYTHON=python2.6' >>.bash_profile

# configure the current session as the profile above
export SPARK=/data/spark15
export SPARK_HOME=$SPARK
export PATH=$SPARK/bin:$PATH
export PYSPARK_PYTHON=python2.6

echo 'configuration: reducing logging for spark'
cp /data/spark15/conf/log4j.properties.template /data/spark15/conf/log4j.properties
sed -i '2s/.*/log4j.rootCategory=ERROR, console/' /data/spark15/conf/log4j.properties

echo 'configuration: expanding memory for spark'
cp /data/spark15/conf/spark-defaults.conf.template /data/spark15/conf/spark-defaults.conf
echo 'spark.driver.memory                7g' >> /data/spark15/conf/spark-defaults.conf
echo 'spark.executor.memory              7g' >> /data/spark15/conf/spark-defaults.conf

# clean up the setup scripts
echo 'clean: removing UCB setup scripts'
rm setup_ucb_complete_plus_postgres.sh
rm setup_spark.sh

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