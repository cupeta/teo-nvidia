#enable Hyprland repo
dnf -y copr enable craftidore/hyprland-prerelease-track
#Install Hyprland  & plugins
dnf -y install  hyprland hyprsunset hyprpaper hyprpolkitagent hyprland-guiutils

### fix for screen sharing
cat > /usr/lib/systemd/user/xdg-desktop-portal.service << EOF
[Unit]
Description=Portal service
#PartOf=graphical-session.target
#Requisite=graphical-session.target
#After=graphical-session.target
### commented out to make xdg-dektop-portal-hyprland work
[Service]
Type=dbus
BusName=org.freedesktop.portal.Desktop
ExecStart=/usr/libexec/xdg-desktop-portal
Slice=session.slice
EOF
