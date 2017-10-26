# Raspbian_OS_Setup
Setup the Raspberry Pi Raspbian OS to be compatible with MATLAB and Simulink support package for Raspberry Pi

**Introduction**

**MATLAB Support package for Raspberry Pi**

With [MATLAB® Support Package for Raspberry Pi™ Hardware](https://www.mathworks.com/discovery/raspberry-pi-programming-matlab-simulink.html) , you can remotely communicate with a Raspberry Pi computer and use it to control peripheral devices. This support allows you to acquire data from sensors and imaging devices connected to the Raspberry Pi.

**Simulink Support package for Raspberry Pi**

[Simulink® Support Package for Raspberry Pi™ Hardware](https://www.mathworks.com/discovery/raspberry-pi-programming-matlab-simulink.html) lets you develop algorithms that run standalone on your Raspberry Pi. The support package extends [Simulink](https://www.mathworks.com/products/simulink.html) with blocks to drive Raspberry Pi digital I/O and read and write data from them. After creating your Simulink model, you can simulate it and download the completed algorithm for standalone execution on the device. One particularly useful (and unique) capability offered by Simulink is the ability to tune parameters live from your Simulink model while the algorithm runs on the hardware.

**Linux Image for Raspberry Pi**

For your Raspberry Pi hardware to be compatible with MATLAB and Simulink support package, the Linux operating system running on the hardware should have all the required software packages and libraries installed. MathWorks ships a custom Linux image for Raspberry Pi. This image comprises of the default Raspbian jessie image with all the required software packages and libraries installed.

MATLAB and Simulink support package for Raspberry Pi also support running Robot Operating System (ROS) on Raspberry Pi. The custom image shipped by MathWorks comes with all the required ROS packages and libraries pre-installed.

**Customization of Raspbian image for MATLAB and Simulink compatibility**

If you would like to create a Linux image for Raspberry Pi which is compatible with MATLAB and Simulink, you must install required software packages and libraries.

Following is the list of required software packages and libraries

**Software Packages**

  1. libsdl1.2-dev
  2. alsa-utils
  3. Espeak
  4. i2c-tools
  5. libi2c-dev
  6. Ssmtp
  7. Ntpdate
  8. git-core
  9. v4l-utils
  10. Cmake
  11. sense-hat
  12. Sox
  13. libsox-fmt-all
  14. libsox-dev

**Libraries**

1. Userland
2. WiringPi
3. PiGPIO

You can use the shell script [RaspbianOSsetup.sh](/RaspbianOSsetup.sh) to install the required packages and libraries along with the ROS specific packages and libraries.

**Instructions for Use**

  1. Follow the instructions provided in the Raspberry Pi official documentation page to download and setup Raspbian OS on your        Raspberry Pi.
  2. Copy the Shell script corresponding to your Raspbian version to the Raspberry Pi hardware. 
  3. On the Raspberry Pi terminal, run the shell script.
  For example
 - chmod u+x RaspbianOSSetup_Jessie.sh
 - ./RaspbianOSSetup_Jessie.sh
 4. On completion of the Shell script, restart your Raspberry Pi to complete the setup

**Testing**

1. Install the MATLAB and Simulink support package for Raspberry Pi in your MATLAB installation.

     Use the link to [Get Support Packages](https://www.mathworks.com/matlabcentral/fileexchange/40313?download=true).

     More Information can be found here

      [MATLAB Support package for Raspberry Pi hardware](https://www.mathworks.com/hardware-support/raspberry-pi-matlab.html)

      [Simulink Support package for Raspberry Pi hardware](https://www.mathworks.com/hardware-support/raspberry-pi-simulink.html)

2.  After successful installation of the support package, connect the hardware to the same network as the host machine running MATLAB.
3. On the MATLAB command prompt, execute the following

   **myrpi = raspi(&#39;Device IP address&#39;,&#39;Username&#39;,&#39;password&#39;)**

  - Device IP address - IP address of your Raspberry Pi

  - Username - Username associated with the login on Raspberry Pi

  - Password - Corresponding password

4. After execution, if the command returns a valid Raspi object, the setup for Raspberry Pi is successful.

