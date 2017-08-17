# moviematch

### Create EC2 Instance

Launch the vanilla UCB AMI `ami-a4c7edb2` from AWS ([shortcut to east-1](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-a4c7edb2)).

* The instance must have at least 8 GB of RAM
* The instance must have at least 20 GB of storage
	  
Download and run the setup script then reboot

      wget https://raw.githubusercontent.com/lukedoolittle/moviematch/master/setup.sh
      chmod +x setup.sh
      ./setup.sh
      sudo reboot
	  
Clone this repository and move into the directory

      git clone https://github.com/lukedoolittle/moviematch.git
      cd moviematch

Load the initial SMALL static set of data (optional)

      ./data/small_data_load.sh

Load the initial static set of data

      ./data/initial_data_load.sh

Load the secondary set of data

      ./data/additional_data_load.sh
      
Build and run webserver

      ./launch.sh