#!/bin/bash

############################
#  Clone Repo
############################
read -n1 -p "Do you need to get the gladiator-pit repo? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
     echo Please type in your bitbucket username.
     read username
     cd $HOME
     git clone https://$username@bitbucket.org/darpactf/gladiator-pit.git
     gladiator_pit_path="$HOME/gladiator-pit"
     cd "$gladiator_pit_path"
     git submodule init
     git submodule update
else
     echo "What is the path to the gladiator-pit repo?"
     read gladiator_pit_path
fi
ros_ws="$gladiator_pit_path/ros-packages"
terra_gazebo_path="$ros_ws/src/terrasentia-gazebo"
echo
echo "The gladiator-pit repo path: $gladiator_pit_path"

################################
#  	Create SwarmbotsConfig file
################################
echo
echo "Creating SwarmbotsConfig file in terrasentia_bridge..."

swarm_dirs="$gladiator_pit_path/terra-simulator/libterra-simulator/include"
cd "$terra_gazebo_path/terrasentia_bridge"
printf "set(SWARMBOTS_DIRS $swarm_dirs)" > SwarmbotsConfig.user.cmake

echo
cat $terra_gazebo_path/terrasentia_bridge/SwarmbotsConfig.user.cmake


#################################################
#  Install Full ROS Kinetic for Ubuntu 16.04
#################################################
read -n1 -p "Do you want to install ROS? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
     # Setup your sources.list
     sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

     # Setup your keys
     sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

     # Install Desktop-Full
     sudo apt-get update
     sudo apt-get install -y ros-kinetic-desktop-full

     # Initialize rosdep
     sudo rosdep init
     rosdep update

     # Setup bash Environment Loading
     echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
     source ~/.bashrc
     source /opt/ros/kinetic/setup.bash

     # Joystick drivers for robot control
     sudo apt install ros-kinetic-joy ros-kinetic-joystick-drivers ros-kinetic-joy-teleop ros-kinetic-teleop-twist-joy
     # Drivers for robot navigation
     sudo apt install ros-kinetic-gmapping ros-kinetic-amcl ros-kinetic-move-base ros-kinetic-map-server ros-kinetic-hector-gazebo*

fi

#################################################
#  Installation steps for ardupilot-gazebo
#################################################
read -n1 -p "Do you want to run ardupilot setup? Enter (y) or (n)" doit
echo
if [[ $doit == "Y" || $doit == "y" ]]; then
  # Install required packages for building Ardupilot firmware
  cd $gladiator_pit_path
  ardupilot/Tools/scripts/install-prereqs-ubuntu.sh -y
  . ~/.profile

  # Install MAVROS
  sudo apt install ros-kinetic-mavros ros-kinetic-mavros-extras

  # add gazebo models to path
  echo 'export GAZEBO_MODEL_PATH="${GAZEBO_MODEL_PATH}${gladiator_pit_path}/ros-packages/src/ardupilot_gazebo/gazebo_models"' >> ~/.bashrc
  source ~/.bashrc

  sudo cp -a ardupilot_gazebo/gazebo_worlds/. /usr/share/gazebo-7/worlds

fi

###########################
#  	Build ROS workspace
###########################
echo
read -n1 -p "Do you want to build your ROS workspace? Enter (y) or (n)" doit

if [[ $doit == "Y" || $doit == "y" ]]; then
     cd $ros_ws
     catkin_make
     source devel/setup.bash
fi

###########################
#  	Build ArduCopter
###########################
# echo
# read -n1 -p "Do you want to build the ArduCopter binary for SITL simulation? Enter (y) or (n)" doit
#
# if [[ $doit == "Y" || $doit == "y" ]]; then
#      cd $gladiator_pit_path
#      echo
#      echo "ArduCopter build not yet implemented"
# fi


echo
echo Done!
