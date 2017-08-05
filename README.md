# moviematch

### Create EC2 Instance

Launch the vanilla UCB AMI `ami-be0d5fd4` from AWS ([shortcut to east-1](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-be0d5fd4)).

* The instance must have at least 8 GB of RAM
* You must attach additional storage in the form of an EBS with at least 20 GB of space.

(optional) Update the instance and reboot

      sudo yum install epel-release && sudo yum update -y && sudo reboot
	  
Download and run the setup script

      wget https://raw.githubusercontent.com/lukedoolittle/moviematch/master/setup.sh
      chmod +x setup.sh
      ./setup.sh
	  
Move into the w205 user and clone this repository

      su - w205
      git clone https://github.com/lukedoolittle/moviematch.git
      cd moviematch

Load the initial static set of data

      ./data/initial_data_load.sh

Load the secondary set of data

      ./data/additional_data_load.sh
      
Build and run webserver

      ./launch.sh