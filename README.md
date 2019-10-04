# ROS-Path-Planning
1.MATLAB planned path output


2.run gazebo and open isris.world


cd ~/src/Firmware

source Tools/setup_gazebo.bash $(pwd) $(pwd)/build/px4_sitl_default

roslaunch gazebo_ros empty_world.launch world_name:=$(pwd)/Tools/sitl_gazebo/worlds/iris1.world

no_sim=1 make px4_sitl_default gazebo


3.launch the simulation and connect ROS to it via MAVROS


roslaunch mavros px4.launch fcu_url:="udp://:14540@127.0.0.1:14557"


4.select extended topic at simulink

5.PX4 takeoff

*rosrun mavros mavsafety arm (Recommended)      pxh> commander takeoff (in no_sim page)

6.Run SIMULINK

7.switch mode

rosrun mavros mavsys mode -c OFFBOARD
