#!/bin/bash

#Time settings
sudo timedatectl set-local-rtc 1 --adjust-system-clock
echo '!-----! Time settings installed'

# Создаем папку Templates в домашней директории пользователя, если ее еще нет
mkdir -p ~/Templates
touch ~/Templates/"Text file"
echo '!-----! NewText option installed successfully!!'

# Добавление ключей и репозиториев
sudo dnf copr enable polter/far2l
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf -y install 'dnf-command(config-manager)'
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
#RPM Fusion
sudo dnf -y install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y install \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo rpm --import https://raw.githubusercontent.com/UnitedRPMs/unitedrpms/master/URPMS-GPG-PUBLICKEY-Fedora
sudo dnf -y install https://github.com/UnitedRPMs/unitedrpms/releases/download/20/unitedrpms-$(rpm -E %fedora)-20.fc$(rpm -E %fedora).noarch.rpm
echo "!-----! New repo's installed"

# Обновляем список пакетов
sudo dnf update

#Install app envirement
sudo dnf group install -y "Development Tools"
sudo dnf -y install gedit grubby gparted p7zip p7zip-plugins vlc mc far2l krusader openrgb neofetch inxi htop papirus-icon-theme zsh neofetch python-launcher java-17-openjdk-headless nodejs php-cli nginx-core pv iftop atop iotop snapd make time perl gcc dkms kernel-devel kernel-headers inxi git wireguard-tools code gh copyq qbittorrent kernel-headers kernel-devel dkms make elfutils-libelf-devel qt5-qtx11extras libxkbcommon
echo '!-----! Main app envirement installed'

# Flatpack apps
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.telegram.desktop
flatpak install flathub org.onlyoffice.desktopeditors
flatpak install flathub com.mattjakeman.ExtensionManager
echo '!-----! Flatpack installed'

#Snap and anbox
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install --classic anbox
sudo snap install stretchly
echo '!-----! Snap and anbox installed'

#install codecs
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install lame\* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia
echo '!-----! codecs installed'

#VAAPI
sudo dnf -y install --enablerepo=rpmfusion-free-updates-testing mesa-va-drivers-freeworld
echo '!-----! VAAPI installed'

# Set ZSH as the default shell for the current user
sudo chsh -s $(which zsh) $(whoami)
echo '!-----! ZSH as the default shell for the current user'

# Create the wireguard configuration file
sudo touch /etc/wireguard/wg0.conf
# Set the appropriate permissions for the configuration file
sudo chmod 0600 /etc/wireguard/wg0.conf
# Add the configuration to the wg0.conf file
sudo sh -c "echo '[Interface]
Address = 10.13.13.4
PrivateKey = UBSEA/9Dwocl3fqINV9QqecelKkaOHrFtfQ0C5L2oEA=
ListenPort = 51820
DNS = 10.13.13.1
[Peer]
PublicKey = 2M3RxLzMp4g1XJtphBsTOSxF90G9yNqgkO/5JfRyzCw=
Endpoint = ua.cidious.com:51820
AllowedIPs = 0.0.0.0/0, ::/0' > /etc/wireguard/wg0.conf"
# Start the Wireguard service using the wg0 configuration file
sudo systemctl start wg-quick@wg0.service
echo '!-----! Vireguard installed and started successfully!!'

# Edit the dnf configuration file
settings="[main]
gpgcheck=True
installonly_limit=3
clean_requirements_on_remove=True
best=False
skip_if_unavailable=True
fastestmirror=True
max_parallel_downloads=10
defaultyes=True
keepcache=True"
if grep -Fxq "$settings" /etc/dnf/dnf.conf; then
echo "!-----! DNF Settings are already present in /etc/dnf/dnf.conf. Nothing to do."
else
# If the settings are not present, add them to the file
echo "$settings" >> /etc/dnf/dnf.conf
echo "!-----! Added DNF settings to /etc/dnf/dnf.conf."
fi

# Restart the computer to apply the changes
for i in {10..1}; do echo "Rebooting in $i seconds..."; sleep 1; done; echo "Rebooting now..."; sudo shutdown -r now
