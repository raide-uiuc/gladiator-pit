# Gladiator Pit
This repository holds all of the code required to run the live DARPA capture the flag demo

## ardupilot
This repo contains the drone autopilot firmware. We're using the v3.6.3 (stable) release.


http://ardupilot.org/dev/docs/using-sitl-for-ardupilot-testing.html



## ardupilot-gazebo
This repo contains a ROS package and example for interfacing with the Ardupilot firmware

## ctf-public
This repo contains the reinforcement learning policy and simple grid world simulation.

#### Installation using Conda (for Python package management)
1. Download and install conda using instructions at https://conda.io/docs/user-guide/install/linux.html

2. In your ~/.bashrc file, remove the line where conda is added to the $PATH variable.

3. Add this line to your ~/.bashrc file
```sh
# enable conda
. $HOME/miniconda3/etc/profile.d/conda.sh
```

4. Create a new Python 2.7 environment called "ctf"
```sh
conda create -n ctf python=2.7 numpy
pip install gym
cd ~/gladiator-pit/ctf_public/gym_cap
python setup.py install
pip install rospkg
```

## terrasentia-gazebo
This repo contains the ROS packages for the terrasentia robot and ctf demo in Gazebo

To start, open a terminal...
```sh
cd $HOME/gladiator-pit/ros-packages/src/terrasentia-gazebo
run_ctf_world.sh
"y" + Enter
roslaunch terrasentia_navigation ari_ctf_waypoint_follower.launch
```

And in a new terminal...
```sh
conda activate ctf
cd $HOME/gladiator-pit/ctf_public
python cap_gazebo.py
```
Now click the play button (or press the spacebar) in the Gazebo simulation to run.
