cd ~/

echo "Clone repo"
git clone https://github.com/Lorem96/arch-install.git

echo "Create config dirs"
mkdir ~/.config/i3
mkdir ~/.config/polybar

echo "Copy configs"
cp ~/arch-install/i3/config ~/.config/i3/config
cp ~/arch-install/polybar/config ~/.config/polybar/config

echo "Download wallpaper"
mkdir -p ~/.config/wallpaper/
curl https://clearvision.gitlab.io/images/sapphire.jpg --output "~/.config/wallpaper/wallpaper.jpg"

echo "Setup yay"
sudo pacman --noconfirm -Syy
sudo pacman --noconfirm -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

echo "Install polybar"
yay -S polybar

exit