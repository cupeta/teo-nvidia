GREEN=$'\e[38;5;46m'
RESET=$'\e[0m'

install_dir=/opt
bin_dir=/opt/bin


echo "${GREEN}finding latest reaper version...${RESET}"
latest_version=$(curl -s https://www.reaper.fm/download.php | grep -oP 'files/[0-9]\.x/reaper[0-9]+_linux_x86_64\.tar\.xz' | head -n1)

echo "${GREEN}latest reaper version is $latest ${RESET}"

wget https://www.reaper.fm/$latest_version
echo "${GREEN}extracting tar archive...${RESET}"
tar -xf reaper*.tar.xz

echo "${GREEN}installing repear in $install_path...${RESET}"
bash reaper*/install-reaper.sh --install /$install_dir 

#echo "${GREEN}installing repear in $install_path...${RESET}"
ln -s $install_dir/REAPER/reaper $bin_dir

chmod +x /opt/REAPER/reaper

echo "${GREEN}cleaning up...${RESET}"
rm -r reaper*.tar.xz
rm -r reaper_linux_x86_64


