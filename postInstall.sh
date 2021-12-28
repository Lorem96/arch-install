cd ~/

echo "Setup yay"
sudo pacman --noconfirm -Syy
sudo pacman --noconfirm -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

echo "Install polybar"
yay -S polybar

exit