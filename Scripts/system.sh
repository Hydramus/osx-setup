#!/bin/bash

# DESCRIPTION
# Install System Software (e.g. Homebrew, Cask etc.)

if ! command -v brew > /dev/null; then
    echo "[SYSTEM] Install Homebrew"
    ruby -e "$(curl --location --fail --silent --show-error https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "[SYSTEM] Update Homebrew"
    brew update
fi
echo ""

echo "[SYSTEM] Install Homebrew Cask"
brew tap caskroom/cask-cask
echo ""

echo "[SYSTEM] Install Brew Bundle"
brew tap Homebrew/bundle
echo ""

echo "[SYSTEM] Update gem"
gem update --system 
echo ""

echo "[SYSTEM] Enabling remote login via SSH"
systemsetup -setremotelogin on
echo ""

read -p "[SYSTEM] Set new hostname? (yes/no): " response
if test "$response" = "yes"; then
        echo ""
        read -p "Enter your e-mail: " newhostname
        echo ""
    echo "[SYSTEM] Setting new hostname to $newhostname"
    scutil --set HostName $newhostname
    scutil --set LocalHostName $newhostname
    scutil --set ComputerName $newhostname
    dscacheutil -flushcache
fi
echo "[SYSTEM] New hostname set to $newhostname"

