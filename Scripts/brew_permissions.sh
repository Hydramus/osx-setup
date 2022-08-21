#!/bin/bash

echo "Changing brew to be able to be used by any users (still, do not run brew as root!)"

echo "Creating new group called brew"

dscl . create /Groups/brew
dscl . create /Groups/brew gid 799
dscl . create /Groups/brew passwd "*"
echo "adding admin user to group."

for i in $(dscl . list /Users | grep -v ^_ | grep -v nobody); do
    echo "dscl . append /Groups/brew GroupMembership $i"
    do dscl . append /Groups/brew GroupMembership $i
done

# can use this to check the group membership
# dscacheutil -q group -a name brew

#Change the group of homebrew installation directory
sudo chgrp -R brew $(brew --prefix)/*

#Allow group members to write inside this directory 
sudo chmod -R g+w $(brew --prefix)/* 
