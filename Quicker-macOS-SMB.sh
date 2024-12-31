#!/bin/bash

# Ensure the script is running with root privileges
if [ "$(id -u)" -ne 0 ]; then
  echo "You need to run this script as root. Please use sudo."
  exit 1
fi

# Backup existing nsmb.conf before making changes
if [ -f /private/etc/nsmb.conf ]; then
  echo "Backing up existing nsmb.conf to /private/etc/nsmb.conf.bak"
  cp /private/etc/nsmb.conf /private/etc/nsmb.conf.bak
fi

# Remove the existing nsmb.conf and create a new one
echo "Removing existing /private/etc/nsmb.conf and applying new settings..."
rm -f /private/etc/nsmb.conf

# Write new settings to nsmb.conf
echo "[default]" > /etc/nsmb.conf
echo "signing_required=no" >> /etc/nsmb.conf
echo "streams=yes" >> /etc/nsmb.conf
echo "notify_off=yes" >> /etc/nsmb.conf
echo "port445=no_netbios" >> /etc/nsmb.conf
echo "unix extensions = no" >> /etc/nsmb.conf
echo "veto files=/._*/.DS_Store/" >> /etc/nsmb.conf
echo "protocol_vers_map=6" >> /etc/nsmb.conf
echo "mc_prefer_wired=yes" >> /etc/nsmb.conf

# Set system preferences to stop writing network store files
echo "Setting system preferences to stop writing network store files..."
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE

# Confirm completion
echo "Changes have been applied successfully."

exit 0
