
#!/bin/bash
repo=sandervocke/shoopdaloop
url=$(curl -s https://api.github.com/repos/$repo/releases/latest | grep -o "[^\"]*x64.AppImage")
appimage=$(basename $url)
command=shoopdaloop

echo "url: $url"
echo "appimage: $appimage"

wget "https://github.com/$repo/releases/latest/download/$appimage"  -P /opt

ln -s /opt/$appimage /opt/bin/$command

chmod 755 /opt/$appimage 

