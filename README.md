# moviematch

### Create EC2 Instance

* Launch the vanilla UCB AMI `ami-be0d5fd4` from AWS ([shortcut to east-1](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-be0d5fd4)). **Note** you must attach additional storage in the form of an EBS with at least 10 GB of space.

* Update the instance and reboot

      sudo yum install epel-release && sudo yum update -y && sudo reboot
	  
* Download and run the setup script

      wget https://raw.githubusercontent.com/lukedoolittle/moviematch/master/setup.sh
      chmod +x setup.sh
      ./setup.sh
	  
* Move into the w205 user and clone this repository

      su - w205
      git clone https://github.com/lukedoolittle/moviematch.git

* Start the Hive metastore and load all of the data

      /data/start_metastore.sh
      cd moviematch/data
      ./initial_data_load.sh
	  
* Build and run server

      cd moviematch/website/moviematch/
      npm i
      npm run start
	  
### Validate Instance

* Test the Node installation

      node moviematch/test/simpleServer.js
      curl http://localhost:8080/
