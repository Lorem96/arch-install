cd ~/.

sudo pacman --noconfirm -Sy git

echo "Clone repo"
git clone https://github.com/Lorem96/arch-install.git

echo "Create config dirs"
mkdir -p ~/.config/i3
mkdir -p ~/.config/polybar
mkdir -p ~/.config/wallpaper

echo "Copy configs"
cp ~/arch-install/i3/config ~/.config/i3/config
cp ~/arch-install/polybar/config ~/.config/polybar/config
cp ~/arch-install/polybar/launch.sh ~/.config/polybar/launch.sh

echo "Download wallpaper"
curl https://clearvision.gitlab.io/images/sapphire.jpg --output ~/.config/wallpaper/wallpaper.jpg

echo "Setup yay"
sudo pacman --noconfirm -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

echo "Install polybar"
yay -S polybar

exit