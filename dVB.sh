#!/bin/bash

#Define download directory
download_dir="$HOME/Downloads/Vbox/"

# Go to the VirtualBox download page
wget -qO- https://www.virtualbox.org/wiki/Downloads > page.html

# Get the list of versions
ver=$(grep -oP 'https://download.virtualbox.org/virtualbox/[0-9]+\.[0-9]+\.[0-9]+/' page.html | sort -rV)

# Get the latest version
new_version=$(echo "$ver" | head -n1 | grep -oP '[0-9]+\.[0-9]+\.[0-9]+')
echo "Latest VirtualBox version: $new_version"
rm page.html

# Build the new version URL
url="https://download.virtualbox.org/virtualbox/${new_version}/"

# Import VirtualBox GPG Key
sudo rpm --import https://www.virtualbox.org/download/oracle_vbox.asc

# Download latest VirtualBox RPM file
latest_version=$(curl -s https://download.virtualbox.org/virtualbox/${new_version}/ | grep "fedora.*\.rpm" | cut -d'"' -f2)
versions=$(curl -s https://download.virtualbox.org/virtualbox/${new_version}/ | grep "fedora.*.rpm" | cut -d'"' -f2)
if [ -z "$versions" ]; then
  echo "No VirtualBox RPM file found in https://download.virtualbox.org/virtualbox/${new_version}/."
  exit 1
fi
latest_version=$(echo "$versions" | sort -V | tail -n 1)
curl -L -o "$download_dir$latest_version" "$url$latest_version"

# Add permissions to VirtualBox RPM file
chmod +x $latest_version

# Install VirtualBox from RPM file
sudo dnf -y install $download_dir$latest_version

# Add your user to the vboxusers group
sudo groupadd vboxusers
sudo usermod -a -G vboxusers $USER
sudo /sbin/vboxconfig

#Define URL of VirtualBox extension pack
extension_pack_url="https://download.virtualbox.org/virtualbox/${new_version}/Oracle_VM_VirtualBox_Extension_Pack-${new_version}.vbox-extpack"

#Define URL of VirtualBox Guest Additions
guest_additions_url="https://download.virtualbox.org/virtualbox/${new_version}/VBoxGuestAdditions_${new_version}.iso"



#Create download directory if it does not exist
if [ ! -d "$download_dir" ]; then
mkdir -p "$download_dir"
fi

#Download VirtualBox Extension Pack
echo "Downloading VirtualBox Extension Pack..."
curl -L -o "${download_dir}Oracle_VM_VirtualBox_Extension_Pack.vbox-extpack" "${extension_pack_url}"

#Download VirtualBox Guest Additions
echo "Downloading VirtualBox Guest Additions..."
curl -L -o "${download_dir}VBoxGuestAdditions_${new_version}.iso" "${guest_additions_url}"

echo "!-----! Latest VirtualBox version ($new_version) is installed!"

