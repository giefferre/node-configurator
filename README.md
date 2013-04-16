#server-configuration 0.1

##1. Intro
The node-configurator application is an automator service which provides with installing/uninstalling capabilities for applications within a system.

It is useful for the base setup of a machine, or when you need to configure a virtualhost.

##2. System requirements

###2.1. Host machine
- An *nix operating system with bash + rsync
- Git
- Python 
- PIP ( http://guide.python-distribute.org/installation.html#installing-pip )
- Fabric ( $ pip install fabric )


###2.2. Destination machine
- Ubuntu 12.04 LTS or 12.10 machine
- OpenSSH service installed and running
- A valid sudoer user


##3. Usage

	$ git clone https://github.com/giefferre/node-configurator.git
	$ cd server-configuration
	$ fab <command>
	
###3.1. Available commands
1. init
2. updatesystem
3. addapplication
4. delapplication

`fab init`:

Will initialize the machine into a base system, with common libraries plus git, python, fabric capabilities.

`fab updatesystem` (or `fab up`):

Will run the package manager to upgrade the system.

`fab addapplication:<application_repository_url>,<application_branch>` (or `fab add:<application_repository_url>,<application_branch>`):

Will try to install the specified <servicename> application.

`fab delapplication:<application_repository_url>,<application_branch>` (or `fab add:<application_repository_url>,<application_branch>`):

Will try to uninstall the specified <application_repository_url> application (if the uninstall feature is present in the specific app).

###3.2. Example
	$ sudo fab -H 192.168.1.139 --user myuser --password mybeautifulpassword init

	$ fab -H 192.168.1.139 --user myuser --password mybeautifulpassword addservice:https://github.com/<username>/<repository>.git,master

##4. Creating an application (beta)
Work in progress

<!-- 
1. Create a directory into **services/** (e.g. **services/new_service**)
2. Create a **fabfile.py**
3. Create **install.pp** and/or other puppet manifests, if needed

***Please note**: no modification should be made on the main fabfile.py in the root folder!*
-->

##5. Creating a puppet module (beta)
Work in progress
