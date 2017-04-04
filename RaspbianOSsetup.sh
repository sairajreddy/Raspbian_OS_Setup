# !/bin/bash
#
# Copyright 2017 The MathWorks, Inc.
#
#  Customize the default Raspberry Pi Raspbian Jessie Lite image to be compatible with MATHWORKS tools
#  Run the following shell script as a sudoer.
#  The default usename is assumed to be pi. If your username is different, change it accorsingle in the following command
username="pi"
echo "Customizing Raspbian Jessie Lite..."
# Update the package repository.
echo "1. Update package repository..."
sudo apt-get -y update
# Upgrade the repository to point to the latest locations
echo "2. Upgrade to latest..."
sudo apt-get -y upgrade
# Install all the required packages. Following are the required packages
# 1. libsdl1.2-dev
# 2. alsa-utils
# 3. espeak
# 4. i2c-tools
# 5. libi2c-dev
# 6. ssmtp
# 7. ntpdate
# 8. git-core
# 9. v4l-utils
# 10. cmake
# 11. sense-hat
echo "3. Installing required software packages..."
sudo apt-get -y install libsdl1.2-dev alsa-utils espeak i2c-tools libi2c-dev ssmtp ntpdate git-core v4l-utils cmake sense-hat
# Clean-up the installation
echo "4. Remove un-needed packages..."
sudo apt-get -y autoremove
# Install rpi-serial-console package
echo "5. Install serial console package..."
sudo wget https://raw.github.com/lurch/rpi-serial-console/master/rpi-serial-console -O /usr/bin/rpi-serial-console
sudo chmod +x /usr/bin/rpi-serial-console
# Install WiringPi
echo "6. Install WiringPi"
sudo mkdir -p /opt/wiringPi
sudo chown $username /opt/wiringPi
git clone git://git.drogon.net/wiringPi /opt/wiringPi
cd /opt/wiringPi
git pull origin
cd /opt/wiringPi
sudo ./build
sudo chown root /opt/wiringPi
# Install Userland
echo "7. Install Userland"
sudo mkdir -p /opt/userland
sudo chown $username /opt/userland
cd /opt
sudo git clone git://github.com/raspberrypi/userland.git
cd /opt/userland
sudo git pull origin
cd /opt/userland
sudo ./buildme
sudo ldconfig
sudo chown root /opt/userland
#Install PiGPIO
echo "8. Install PiGPIO "
sudo mkdir -p /opt/PIGPIO
sudo chown $username /opt/PIGPIO
wget abyz.co.uk/rpi/pigpio/pigpio.zip
sudo unzip pigpio.zip -d /opt
cd /opt/PIGPIO
sudo make
cd /opt/PIGPIO
sudo make install
rm -f pigpio.zip
sudo chown root /opt/PIGPIO
# Install ROS
# Change the swap size to 500
echo "9. Installing ROS"
echo "9.1 Changing swap size to 500"
sudo sed -ie 's/CONF_SWAPSIZE/#CONF_SWAPSIZE/g' /etc/dphys-swapfile
sudo sed -i '$ a CONF_SWAPSIZE=500' /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
set -e
installCollado() {
    # Install collada-dom-dev
    mkdir ~/ros_catkin_ws/external_src
    sudo apt-get -y install checkinstall cmake
    sudo sh -c 'echo "deb-src http://mirrordirector.raspbian.org/raspbian/ testing main contrib non-free rpi" >> /etc/apt/sources.list'
    sudo apt-get update
    cd ~/ros_catkin_ws/external_src
    sudo apt-get -y install libboost-filesystem-dev libxml2-dev
    wget http://downloads.sourceforge.net/project/collada-dom/Collada%20DOM/Collada%20DOM%202.4/collada-dom-2.4.0.tgz
    tar -xzf collada-dom-2.4.0.tgz
    cd collada-dom-2.4.0
    cmake .
    sudo checkinstall -y make install
}
# Install dependencies
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu jessie main" > /etc/apt/sources.list.d/ros-latest.list'
wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install python-pip python-setuptools python-yaml python-distribute python-docutils python-dateutil python-six
sudo pip install rosdep rosinstall_generator wstool rosinstall
sudo rosdep init
rosdep update
mkdir ~/ros_catkin_ws
cd ~/ros_catkin_ws
rosinstall_generator ros_comm rosout std_msgs sensor_msgs geometry_msgs  --rosdistro indigo --deps --wet-only --exclude roslisp --tar > indigo-ros_comm-wet.rosinstall
wstool init src indigo-ros_comm-wet.rosinstall
# Download ROS packagesto
rosdep install --from-paths src --ignore-src --rosdistro indigo -y -r --os=debian:jessie
# Build ROS packages
# Increase swap file size before this step to avoid internal C++ compiler
# error
#sudo nano /etc/dphys-swapfile
#sudo dphys-swapfile setup
#sudo dphys-swapfile swapon
sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/indigo
# Source setup script for ROS Indigo
source /opt/ros/indigo/setup.bash
# Initialize ROS user workspace ~/catkin_ws
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src
catkin_init_workspace
# Build ROS user workspace. This step creates devel and build directories under the ~/catkin_ws.
cd ~/catkin_ws/
catkin_make
echo "9.2 Reverting swap file changes"
sudo sed -i '/CONF_SWAPSIZE=500/d' /etc/dphys-swapfile
sudo sed -ie 's/#CONF_SWAPSIZE/CONF_SWAPSIZE/g' /etc/dphys-swapfile
# Add user to video and i2c user group
echo "10. Adding user to video group..."
sudo adduser pi video
echo "11. Adding user to i2c group..."
sudo adduser pi i2c
echo "Customization Complete..."
