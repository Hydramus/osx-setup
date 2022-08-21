#!/bin/bash

echo "Changing brew to be able to be used by any users (still, do not run brew as root!)"

echo "Creating new group called brew"

dscl . create /Groups/brew
dscl . create /Groups/brew gid 799
dscl . create /Groups/brew passwd "*"
echo "adding admin user to group."

for i in $(dscl . list /Users | grep -v ^_ | grep -v nobody); do
    echo "dscl . append /Groups/brew GroupMembership $i"
    dscl . append /Groups/brew GroupMembership $i
done

# can use this to check the group membership
# dscacheutil -q group -a name brew

echo "Adding brew group to all brew directories"
#Change the group of homebrew installation directory
chgrp -Rv brew $(brew --prefix)/*

#Allow group members to write inside this directory 
chmod -Rv g+w $(brew --prefix)/* 

#Allowing git config to add /opt/homebrew to safe directory
git config --global --add safe.directory /opt/homebrew
git config --global --add safe.directory /opt/homebrew/Library/Taps/homebrew/homebrew-cask
git config --global --add safe.directory /opt/homebrew/Library/Taps/homebrew/homebrew-core
git config --global --add safe.directory /opt/homebrew/Library/Taps/homebrew/homebrew-bundle


echo "All brew folders have been updated with the new group"

