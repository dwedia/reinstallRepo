# reinstallRepo - Unified Reinstallation for Linux

This is my script for reinstallation on linux desktops. So far it should work on Debian based, and RedHat based distributions. It has been tested on Debian 12, Ubuntu 24.04, Fedora Workstation 39 and Fedora Workstation 40.



### How does it work

This script uses Ansible-core for most of its tasks. It is designed to be run on a freshly installed OS, and will set up the most common things I want done (make sure the correct folders are in my $PATH, install desired packages and flatpaks, and remove undesired autoinstalled packages).



It follows this path:

1. Checks /etc/os-release to determine which distro it is running on, and saves the result to a variable.

2. Checks if ansible is installed. If not it will install ansible-core

3. Checks if ansible is installed. if it is, it will install the community.general collection from Ansible Galaxy.

4. Checks if ansible is installed. If it is, it will use ansible to run the reinstall playbook. This will go through the following steps:
   
   1. Run the systemSetup role, which makes sure that ~/.local/bin and ~/.local/scripts folders are created, and adds them to the $PATH variable. It then creates my gitrepos folder and two subfolders for git repo organization
   
   2. Next it runs the Package setup role, which will either call the aptInstall or dnfInstall tasks depending on the package manager on the system. These install the packages I know I want on my system (and remove preinstalled packages that I know i do not want).
   
   3. Run the flatpakInstall role, which will enable flathub as a flatpak repo, and then install the flatpaks I know I want.

5. Ask for desired git global username and user email, and run git config --global to set these.

6. Sets up sane firewall defaults. Will use firewalld on Fedora, and UFW on Debian or Ubuntu.



This is a working repo, that will get changes over time, as I figure out new stuff I want done, or new packages I want installed from the start.
