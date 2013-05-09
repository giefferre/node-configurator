from fabric.api import *
from fabric.contrib.project import *
from fabric.context_managers import cd
from fabric.colors import blue, cyan, red, yellow, green
from fabric.contrib.console import confirm
from fabric.contrib.files import exists

env.warn_only = True

FULL_PATH, _ = os.path.split(os.path.realpath(__file__))
_, DIRECTORY_NAME = os.path.split(FULL_PATH)

def update_modules():
	print(blue("Syncing files...", bold=True))
	rsync_project("/tmp/")
	sudo("cp /tmp/%s/puppet/modules/* /etc/puppet/modules/ -R" % DIRECTORY_NAME)


@task(alias='up')
def updatesystem():
	print(blue("Updating remote system...", bold=True))
	sudo('apt-get update -y')
	sudo('apt-get upgrade -y')


@task
def init():
	print(yellow("This command will initialize the system!", bold=True))
	confirmation = confirm(yellow("Do you want to continue?"), default=False)

	if not confirmation:
		print(red("Aborting", bold=True))

	else:
		updatesystem()

		print(blue("Installing dependencies...", bold=True))

		sudo('apt-get install puppet-common -y')

		update_modules()

		print(blue("Applying base manifest...", bold=True))
		sudo("puppet apply /tmp/%s/puppet/base.pp" % DIRECTORY_NAME)

		sudo('pip install pycrypto==2.6 paramiko==1.10.1 Fabric==1.6.0')


@task(alias='add')
def addapplication(repoUrl, repoBranch = 'master'):
	import os

	repoName = os.path.split(repoUrl)[1]

	print blue("Attempting to clone branch '%s' of '%s' ..." % (repoBranch, repoUrl), bold=True)
	run("rm -rf /tmp/%s" % repoName)
	run("git clone -b %s %s /tmp/%s" % (repoBranch, repoUrl, repoName))

	service_is_valid = exists("/tmp/%s" % (repoName)) & \
		exists("/tmp/%s/deploy/install.sh" % (repoName)) & \
		exists("/tmp/%s/deploy/install.pp" % (repoName))

	if service_is_valid:
		print green("OK, %s has a valid application installer..." % repoName, bold=True)
		update_modules()
		sudo("puppet apply /tmp/%s/deploy/install.pp" % repoName)
		with cd("/tmp/%s/deploy/" % repoName):
			sudo("sh ./install.sh")

	else:
		print red('INVALID application!', bold=True)
		run("rm -rf /tmp/%s" % (repoName))


@task(alias='del')
def delapplication(repoUrl, repoBranch = 'master'):
	import os

	repoName = os.path.split(repoUrl)[1]

	print blue("Attempting to clone branch '%s' of '%s' ..." % (repoBranch, repoUrl), bold=True)
	run("rm -rf /tmp/%s" % repoName)
	run("git clone -b %s %s /tmp/%s" % (repoBranch, repoUrl, repoName))

	service_is_valid = exists("/tmp/%s" % (repoName)) & \
		exists("/tmp/%s/deploy/uninstall.sh" % (repoName)) & \
		exists("/tmp/%s/deploy/uninstall.pp" % (repoName))

	if service_is_valid:
		print green("OK, %s has a valid application uninstaller..." % repoName, bold=True)
		update_modules()
		sudo("puppet apply /tmp/%s/deploy/uninstall.pp" % repoName)
		with cd("/tmp/%s/deploy/" % repoName):
			sudo("sh ./uninstall.sh")

	else:
		print red('INVALID application!', bold=True)
		run("rm -rf /tmp/%s" % (repoName))
