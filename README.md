# moviematch

### Create EC2 Instance

* Launch the vanilla UCB AMI `ami-be0d5fd4` from AWS ([shortcut to east-1](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-be0d5fd4)). **Note** you must attach additional storage in the form of an EBS with at least 20 GB of space.

* (optional) Update the instance and reboot

      sudo yum install epel-release && sudo yum update -y && sudo reboot
	  
* Download and run the setup script

      wget https://raw.githubusercontent.com/lukedoolittle/moviematch/master/setup.sh
      chmod +x setup.sh
      ./setup.sh
	  
* Start the Hive metastore and Mongodb, move into the w205 user and clone this repository

      /data/start_metastore.sh
      service mongod start
      su - w205
      git clone https://github.com/lukedoolittle/moviematch.git

* Load the initial static set of data

      cd moviematch/data
      ./initial_data_load.sh

* Load the secondary set of data

      ./additional_data_load.sh
      
* Build and run webserver

      cd moviematch/webserver
      npm i
      npm run start

* Build and run apiserver

      cd moviematch/apiserver
      npm i
      node src/server.js