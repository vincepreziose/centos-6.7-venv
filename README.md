Set up a virtual machine for developing Softphusion website projects on Magento CE 1.9

## Prerequisites

* [VirtualBox][]
* [Vagrant][]


## Setup

These instructions assume you are using OSX or some flavour of Linux and are familiar with using the terminal to make commands. If you're using Windows there may be some other dependencies for doing command line - [mysysgit](https://github.com/msysgit/msysgit) is quite popular for git related tasks.

Create a folder named <Project Name> in your system

Make the following commands:

    $ cd <Project Name>

Clone repos in <Project Name>

    $ git clone git@github.com:vincepreziose/<repo name>.git
    $ git clone git@github.com:vincepreziose/centos-6.7-venv.git	

Now you are having folders <repo name> and <centos-6.7-venv> in muradproject.  Installing vbguest plugin is recommended or the shared folders may not work properly.

    $ cd centos-6.7-venv
    $ vagrant plugin install vagrant-vbguest
    $ vagrant up
    
After the initial provisioning you MUST reload the VM to use the updated files:
    $ vargrant reload

This will take a while the first time it runs as it will download and configure a new virtual machine and set up the dependencies and config for your project along with database(make sure you have database (murad_114_db.sql.gz) is there in your murad-dev-env folder )

    if your vagrant halts due to network or any other issue please run below command
    $ vagrant reload --provision

**Be careful as provision will rebuild your database, destroying any data you may have added during development**

## Configuration

1. Required, add records to `/etc/hosts` on the host machine to point to the websites on the virtual machine's private ip:

# VM Sites
192.168.33.10   <nginx-server-name>.sb

2. Optionally, change the private IP if it conflicts with anything on your network - default is 192.168.33.10.

3. Once provision is over you can see a local.xml created in /murad_upgrade/app/etc . Please update mysql password to root123 and save the file.

You should now be able to open the development websites from your browser.

## Package Includes

1. PHP    5.6
2. Mysql  5.6..x
3. Nginx  1.8.x
4. CentOS 6.7


## Accessing the Database

To access the database on the VM you need to connect to it over ssh. Note that Vagrant uses port 2222 by default for SSH connections. From inside this project run:

    $ vagrant ssh

Then to connect to the database:

    vagrant@precise32:~$ mysql --user=root --password=root123 murad_114_db // THIS NEEDS TO BE CHANGED!
	
#To Access the project code
Go to folder "<Project Name>/<repo name>" where you have pulled/cloned the code from the git

## Stopping Virtual Machine

If the machine is running  and you need to stop it , use this command `vagrant halt`

## Start/Restart Virtual Machine

If you need to start/restart it , use this command `vagrant reload`




[VirtualBox]:https://www.virtualbox.org/
[Vagrant]:http://www.vagrantup.com/
[Vagrant Documents]:https://docs.vagrantup.com/v2/


=============================================================================================================================================

In case of local set up with XAMPP installation:
Download XAMPP from https://www.apachefriends.org/download.html
Download Git from: https://git-scm.com/download/win

Clone the project from: xampp/htdocs/ - This is where the code will be downloaded. The clone URL can come from Assembla.
DB needs to be created too, contact one of the team members for the same. 

Some useful Git commands:
http://zackperdue.com/tutorials/super-useful-need-to-know-git-commands

Team members using XAMPP installation locally may find these resources useful:

https://ironion.com/blog/2012/10/04/installing-magento-on-xampp-2/

