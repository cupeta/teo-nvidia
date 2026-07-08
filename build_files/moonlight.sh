
repo="moonlight-stream/moonlight-qt"
install_dir=/opt
bin_dir=/opt/bin
bin=moonlight
appimage=$(curl -s https://api.github.com/repos/$repo/releases/latest | grep -o "[^\"]*x86_64.AppImage" | head -1)
echo "appimage name: $appimage"

url=https://github.com/$repo/releases/latest/download/$appimage
echo "the download url is $url"

wget "$url" -P $install_dir

ln  $install_dir/$appimage $bin_dir/$bin
chmod 755 $install_dir/$appimage
chmod +x $bin_dir/$bin
