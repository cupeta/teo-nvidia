dnf -y install ly
systemctl disable lightdm.service
systemctl disable getty@tty2.service
systemctl enable ly@tty2.service
