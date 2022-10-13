#!/bin/bash

# DESCRIPTION
# Install System Software (e.g. Homebrew, Cask etc.)

export loggedInUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

if ! command -v brew > /dev/null; then
    echo "[SYSTEM] Install Homebrew"
    ruby -e "$(curl --location --fail --silent --show-error https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "[SYSTEM] Update Homebrew"
    brew update
fi
echo ""

echo "[SYSTEM] to accomodate for Apple Silcon change to the pathing"
echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.zshrc
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

echo "[SYSTEM] Checking if device is apple silicon and needs Rosetta 2 installed"
./rosetta-2-install.sh
echo ""


echo "[SYSTEM] Enabling remote login via SSH"
#!/bin/sh
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -targetdisk / -activate -configure -clientopts -setmenuextra -menuextra no 
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -targetdisk / -configure -users admin -access -on -privs -all
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -targetdisk / -configure -allowAccessFor -specifiedUsers -privs -all
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -targetdisk / -restart -agent -menu
/usr/sbin/systemsetup -setremotelogin on
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -config -clientopts -setmenuextra -menuextra no
echo ""

read -p "[SYSTEM] Set new hostname? (yes/no): " response
if test "$response" = "yes"; then
        echo ""
        read -p "Enter the new hostname: " newhostname
        echo ""
    echo "[SYSTEM] Setting new hostname to $newhostname"
    scutil --set HostName $newhostname
    scutil --set LocalHostName $newhostname
    scutil --set ComputerName $newhostname
    dscacheutil -flushcache
fi
echo "[SYSTEM] New hostname set to $newhostname"

echo "[SYSTEM] Set up default dock layout"
cp -f "./configfiles/com.apple.dock.plist" "/Users/$loggedInUser/Library/Preferences/"
defaults read "/Users/$loggedInUser/Library/Preferences/com.apple.dock.plist"
killall Dock

echo "[SYSTEM] Default dock layout configured"

