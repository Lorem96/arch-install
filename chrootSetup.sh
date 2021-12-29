username=$1
hostname=$2

echo "Set System Language"
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8"  >> /etc/locale.conf
export LANG=en_US.UTF-8

echo "Set zoneinfo"
ln -sf /usr/share/zoneinfo/Europe/Kiev /etc/localtime
hwclock --systohc --utc

echo "Set hostname"
echo ${hostname} >> /etc/hostname

echo "Set root password"
passwd
useradd -mg users -G wheel,storage,power -s /bin/bash ${username}

echo "Set ${username} password"
passwd ${username}
pacman --noconfirm -Sy sudo dhcpcd

echo "Enable dhcpcd"
systemctl enable dhcpcd

echo "Install video drivers"
pacman --noconfirm -S nvidia nvidia-utils

echo "Install xorg"
pacman --noconfirm -S xorg xorg-xinit xterm xorg-xeyes xorg-xclock

echo "Install i3-gaps and graphical shit"
pacman --noconfirm -S i3-gaps ttf-dejavu i3status i3blocks rofi nitrogen

echo "Install login greeter"
pacman --noconfirm -S lightdm lightdm-gtk-greeter

systemctl enable lightdm

echo "Install software"
pacman --noconfirm -S chromium p7zip p7zip-plugins unrar tar rsync

echo "Install codecs"
pacman --noconfirm -S exfat-utils fuse-exfat a52dec faac faad2 flac jasper lame libdca libdv gst-libav libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gstreamer0.10-plugins flashplugin libdvdcss libdvdread libdvdnav gecko-mediaplayer dvd+rw-tools dvdauthor dvgrab

echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo "Install bootloader"
pacman --noconfirm -Sy grub efibootmgr dosfstools os-prober mtools

grub-install --target=x86_64-efi  --bootloader-id=grub_uefi --recheck

grub-mkconfig -o /boot/grub/grub.cfg

exit