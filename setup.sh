#!/bin/bash
# create the data directory to work from
mkdir data
chmod a+rwx /data

# run the UCB setup script which installs Hadoop, Postgres, and Hive
wget https://s3.amazonaws.com/ucbdatasciencew205/setup_ucb_complete_plus_postgres.sh
chmod +x ./setup_ucb_complete_plus_postgres.sh
./setup_ucb_complete_plus_postgres.sh /dev/xvdb

# run the UCB spark setup script which installs and configures Spark
wget https://s3.amazonaws.com/ucbdatasciencew205/setup_spark.sh
bash ./setup_spark.sh

# add pyspark, spark-sql to path for w205 and root
# and change the pyspark interpreter to use python 2.6
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

# supress logging output from spark-submit jobs
cp /data/spark15/conf/log4j.properties.template /data/spark15/conf/log4j.properties
sed -i '2s/.*/log4j.rootCategory=ERROR, console/' /data/spark15/conf/log4j.properties

# clean up the setup scripts
rm setup_ucb_complete_plus_postgres.sh
rm setup_spark.sh

# download the installer and install
yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_8.x | bash -
yum install -y nodejs