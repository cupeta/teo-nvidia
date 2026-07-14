
repo="moonlight-stream/moonlight-qt"
install_dir=/opt
bin_dir=/opt/bin
bin=moonlight
url=https://github.com/moonlight-stream/moonlight-qt/releases/download/v6.1.0/Moonlight-6.1.0-x86_64.AppImage
appimage=Moonlight-6.1.0-x86_64.AppImage

wget "$url" -P $install_dir

ln  $install_dir/$appimage $bin_dir/$bin
chmod 755 $install_dir/$appimage
chmod +x $bin_dir/$bin
