#!/bin/bash

# Check for distribution
DISTRO=$(cat /etc/os-release | grep PRETTY | awk -F '"' '{print $2}' | awk '{print $1}')

echo "Distrobution is $DISTRO, using correct options"

echo ""
echo "=========================================="
echo "Installing Ansible if not present"
echo "=========================================="
echo ""

# Install ansible-core on Fedora
if [ "Fedora" = $DISTRO ];
then
  if [ ! -f /usr/bin/ansible ]; 
  then
    sudo dnf install -y ansible-core;
    echo "Ansible-core has been installed, running install playbook";
  else
    echo "Ansible-core already installed, running playbook"
  fi
fi

# Install ansible-core on Debian
if [ "Debian" = $DISTRO ] || [ "Ubuntu" = $DISTRO ];
then
  if [ ! -f /usr/bin/ansible ]; 
  then
    sudo apt install -y ansible-core;
    echo "Ansible-core has been installed, running install playbook";
  else
    echo "Ansible-core already installed, running playbook"
  fi
fi

# install the community general flatpak module
ansible-galaxy collection install community.general

echo ""
echo "=========================================="
echo "Running ansible playbook"
echo "=========================================="
echo ""

# Check if ansible is installed, and if so, run the reinstall playbook.
if [ -f /usr/bin/ansible ]; 
then
  ansible-playbook reinstall-playbook.yml -K;
fi

echo ""
echo "=========================================="
echo "Setting git global settings"
echo "=========================================="
echo ""

# Ask for git username and email and put them in variable
read -p "Enter your Git username: " gitUserName
read -p "Enter your Git User Email: " gitUserEmail

# Check if username or email is empty. if not, set git username and email
if [[ -z "$gitUserName" || -z "$gitUserEmail" ]]; then
  echo "Error: Username and email cannot be empty!"
  sleep 10
  exit 1
else
  git config --global user.name "$gitUserName"
  git config --global user.email "$gitUserEmail"
  echo "Git username and email set successfully!"
  sleep 5
fi

echo ""
echo "=========================================="
echo "Setting firewall rules"
echo "=========================================="
echo ""

# Set up firewall with firewalld if Distribution is Fedora
if [ "Fedora" = $DISTRO ];
then
  sudo firewall-cmd --set-default-zone=drop
  sudo firewall-cmd --runtime-to-permanent
  sudo firewall-cmd --reload
fi

# setup firewall with ufw, if Distribution is Debian
if [ "Debian" = $DISTRO ];
then
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw enable
fi

read -p "Setup done, Reboot now? (y/n): " confirm && [[ $confirm == "y" ]] && reboot
