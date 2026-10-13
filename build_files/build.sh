#!/bin/bash

set -ouex pipefail

# dnf speedup
sed -i '/^\[main\]/a max_parallel_downloads=10' /etc/dnf/dnf.conf
# set up custom /opt/bin folder for extra apps (non-dnf software,like AppImages)
mkdir /opt/bin
# add /opt/bin path to system-wide bashrc and etc/profile
echo 'export PATH="$PATH:/opt/bin"' | tee -a /etc/bash.bashrc
echo 'export PATH="$PATH:/opt/bin"' |  tee /etc/profile.d/opt-bin_path.sh
chmod +x /etc/profile.d/opt-bin_path.sh
# SYSTEM APPS
# fuse2 libs for some AppImages to work correctly
dnf -y install fuse-libs
# power settings\battery managment for laptops
dnf -y install power-profiles-daemon  --allowerasing
# cifs-utils for samba mounts
dnf -y install cifs-utils
# Tailscale for private vpn
dnf -y install tailscale
#drivers for connecting android devices
dnf -y install android-tools

#cuda drivers for llm
#dnf -y install nvidia-driver-cuda
# nvtop for monitoring nvidia gpu
dnf -y install nvtop
# DESKTOP ENVIRONMENT
# remove gnome
dnf  -y remove @gnome-desktop
# Hyprland window manager
export pkg=hyprland
if dnf -q repoquery --available --queryformat '%{name}' "$pkg" | grep -Fxq "$pkg"; then
echo $pkg available
else
bash /ctx/hyprland.sh
fi
# waybar
dnf -y install waybar
# wofi (menu and app launcher)
dnf -y install wofi
# gtk customization tool

export pkg=nwg-look
export copr=tofik/nwg-shell
if dnf -q repoquery --available --queryformat '%{name}' "$pkg" | grep -Fxq "$pkg"; then
echo $pkg available
else
    dnf -y copr enable "$copr"
fi
dnf -y install "$pkg"

# DESKTOP APPS
# terminal
export pkg=ghostty
export copr=ponesicek/ghostty-bin
if dnf -q repoquery --available --queryformat '%{name}' "$pkg" | grep -Fxq "$pkg"; then
echo $pkg available
else
    dnf -y copr enable "$copr"
fi
dnf -y install "$pkg"
# file manager
dnf -y install pcmanfm
# ark for opening archives
dnf -y install ark
# web browser & internet tools
dnf -y install firefox transmission
# audio utils
dnf -y install qpwgraph easyeffects vlc
# office & productiviy
dnf -y install libreoffice mousepad homebank galculator telegram-desktop
# graphic design & photo editing
dnf -y install inkscape gimp blender
# kmonad for keyboard macros
dnf -y install kmonad

# REMOTE DEKSTOP
#wf-recorder for screen sharing
dnf -y install wf-recorder
# Sunshine (server)
dnf copr enable -y lizardbyte/stable
dnf -y install Sunshine
# Moonlight (client)
bash /ctx/moonlight.sh

# CODING & DEV TOOLS
# setup lua (RakuOS seems to force overlay install for luarocks...?)
# bash /ctx/lua.sh
# cosign for OCI image signing
bash /ctx/cosign.sh

#AI 
#requirments for unsloth
dnf -y install cmake git gcc gcc-c++ make libcurl-devel


# MUSIC PRODUCTION
# ycollect/audinux repo with many audio plugins
dnf -y copr enable ycollet/audinux
# fix for apps loking for libjack.so in /usr/lib64
ln -s /usr/lib64/pipewire-0.3/jack/libjack.so.0 /usr/lib64/libjack.so
# libraries for some audio plugins to work correctly
dnf -y install lv2-gtk-ui-bridge
dnf -y install JUCE
dnf -y install zenity
# DAW plugins
dnf -y install guitarix lsp-plugins
# install Musescore music sheet editor
bash /ctx/musescore.sh
# install Reaper
bash /ctx/reaper.sh
# install shoopdaloop looper
bash /ctx/shoopdaloop.sh

# VIDEO EDITING
#f ully-featured ffmpeg & OBS with nonfree components from rpm fusion (from morrolinux/morros)
dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf -y install ffmpeg x264-libs obs-studio obs-studio-plugin-x264 --allowerasing

#GAMING
# packages list copied from rakuos setup-gaming
dnf -y install steam lutris lact goverlay mangohud mangohud.i686 protonplus protontricks vkBasalt vkBasalt.i686
export pkg=heroic-games-launcher
if dnf -q repoquery --available --queryformat '%{name}' "$pkg" | grep -Fxq "$pkg"; then
 echo $pkg available
 dnf -y install "$pkg"
else
  wget "$(curl -fsSL https://api.github.com/repos/Heroic-Games-Launcher/HeroicGamesLauncher/releases/latest |
  grep 'browser_download_url' |
  grep '\.rpm' |
  head -n 1 |
  cut -d '"' -f 4)"
  dnf -y install ./Heroic*.rpm 
fi
# Prismlauncher for Minecraft
export pkg=prismlaucher
export copr=xiaozhangup/prismlauncher
if dnf -q repoquery --available --queryformat '%{name}' "$pkg" | grep -Fxq "$pkg"; then
echo $pkg available
else
    dnf -y copr enable "$copr"
    
    if dnf -q repoquery --available --queryformat '%{name}' "$pkg" | grep -Fxq "$pkg"; then
      dnf -y install "$pkg"
    else
      echo pakage $pkg not found in copr $copr
    fi
fi

#VIRTUAL MACHINES
dnf -y install quickemu

#POST INSTALL

#listing installed nvidia packages
#dnf list --installed | grep "nvidia"

#greeter
bash /ctx/ly.sh

# enable systemd units
systemctl enable podman.socket
#systemctl enable tailscaled
# clean up dnf cache to reduce image size
dnf -y clean all
rm -rf /run/dnf /run/selinux-policy
rm -rf /var/lib/dnf

############################
# Install packages
# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
#https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# Use a COPR Example:

# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
