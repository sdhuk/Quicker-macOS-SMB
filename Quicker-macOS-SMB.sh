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

# Disable SMB signing (insecure but might be necessary for some networks)
# SMB signing ensures the integrity of SMB messages but can be disabled in less secure environments.
echo "signing_required=no" >> /etc/nsmb.conf

# Enable SMB Streams support (allows support for file streams)
# Stream support is useful for some advanced file types, such as database files.
echo "streams=yes" >> /etc/nsmb.conf

# Disable SMB notifications (turn off change notification for SMB shares)
# Prevents SMB from sending notifications when files are changed on the network share.
echo "notify_off=yes" >> /etc/nsmb.conf

# Disable NetBIOS over port 445 (NetBIOS is often not needed in modern SMB configurations)
# This disables the older NetBIOS protocol that uses port 445 for network communication, relying solely on SMB.
echo "port445=no_netbios" >> /etc/nsmb.conf

# Disable UNIX extensions in SMB (disables UNIX file system features)
# By default, UNIX extensions are enabled for sharing with UNIX-based systems. Disabling can avoid compatibility issues with Windows servers.
echo "unix extensions = no" >> /etc/nsmb.conf

# Prevent the creation of .DS_Store files on network shares
# .DS_Store files are metadata files used by macOS. This setting avoids their creation on shared folders, useful for network environments.
echo "veto files=/._*/.DS_Store/" >> /etc/nsmb.conf

# Force the use of SMB protocol versions 2 or 3 (disables legacy versions 1)
# Version 1 of SMB is outdated and insecure, so this ensures only newer versions (2 or 3) are used for file sharing.
echo "protocol_vers_map=6" >> /etc/nsmb.conf

# Prefer wired (Ethernet) connections over wireless for SMB file sharing
# Useful for ensuring more stable connections when transferring large files over a network.
echo "mc_prefer_wired=yes" >> /etc/nsmb.conf

# Set system preferences to stop writing network store files
# This disables the creation of .DS_Store files on network shares, improving cross-platform compatibility.
echo "Setting system preferences to stop writing network store files..."
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE

# Confirm completion
echo "Changes have been applied successfully."

exit 0
