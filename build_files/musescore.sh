
#!/bin/bash
install_dir=/opt
bin_dir=/opt/bin

repo="musescore/MuseScore"
bin=mscore

appimage=$(curl -s https://api.github.com/repos/$repo/releases/latest | grep -o "[^\"]*x86_64.AppImage" | head -1)
echo "appimage name: $appimage"

url=https://github.com/$repo/releases/latest/download/$appimage
echo "the download url is $url"

wget "$url" -P $install_dir

ln  $install_dir/$appimage $bin_dir/$bin
chmod 755 $install_dir/$appimage 
chmod +x $bin_dir/$bin

#install Muse Sounds Manager
wget https://muse-cdn.com/Muse_Sounds_Manager_x64.rpm
dnf -y install ./Muse_Sounds_Manager_x64.rpm
#clean up
rm Muse_Sounds_Manager_x64.rpm

