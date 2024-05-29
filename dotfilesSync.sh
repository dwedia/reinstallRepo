#!/bin/bash

# Prompt the user for a Git repository URL
read -p "Enter the Git repository URL: " repo_url

# Validate if the input is not empty
if [ -z "$repo_url" ]; then
    echo "Repository URL cannot be empty."
    exit 1
fi

# Store the repository URL in a variable
repository=$repo_url

# check if our temporary dotfiles folder exists, if it does, delete it.
if [ -d "$HOME/dotfiles-tmp" ]; then
    rm -rf $HOME/dotfiles-tmp
fi

# make the dotfiles-tmp folder
mkdir -p $HOME/dotfiles-tmp

# Clone the repository
git clone --separate-git-dir=$HOME/dotfilesGIT "$repository" $HOME/dotfiles-tmp

# copy the files to the correct locations.
rsync --recursive --verbose --exclude '.git' $HOME/dotfiles-tmp $HOME/

# check if our temporary dotfiles folder exists, if it does, delete it.
if [ -d "$HOME/dotfiles-tmp" ]; then
    rm -rf $HOME/dotfiles-tmp
fi

# rm -rf $HOME/dotfiles-tmp