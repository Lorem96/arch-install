device="/dev/sda"
hostname="lorem-pc"
username="lorem"

echo "Create partitions"
parted ${device} mklabel gpt
sgdisk ${device} -n=1:0:+1024M -t=1:ef00

echo "Create swap"
swapsize=$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')
swapsize=$((${swapsize}/1000))"M"
sgdisk ${device} -n=2:0:+${swapsize} -t=2:8200

echo "Create root"
sgdisk ${device} -n=3:0:0
echo ""

if [ "${device::8}" == "/dev/nvm" ]; then
				bootdev=${device}"p1"
				swapdev=${device}"p2"
				rootdev=${device}"p3"
			else
				bootdev=${device}"1"
				swapdev=${device}"2"
				rootdev=${device}"3"
			fi

echo "bootdev" + ${bootdev}
echo "swapdev" + ${swapdev}
echo "rootdev" + ${rootdev}

echo "Format bootdev, rootdev, swapdev"
mkfs.fat -F32 ${bootdev}
mkfs.ext4 ${rootdev}
mkswap ${swapdev}

echo "Mount bootdev, rootdev, swapdev"
mount ${rootdev} /mnt
mkdir -p /mnt/boot/efi
mount ${bootdev} /mnt/boot/efi
swapon ${swapdev}

echo "Update mirrors list"
reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

echo "Install Arch Soul :)"
pacstrap /mnt/ base linux linux-firmware net-tools networkmanager openssh vi mc nano

echo "Create fstab"
genfstab -U -p /mnt >> /mnt/etc/fstab

echo "Chroot"
cp -d chrootSetup.sh /mnt/chrootSetup.sh
arch-chroot /mnt /bin/bash /chrootSetup.sh ${username} ${hostname}
rm /mnt/chrootSetup.sh

echo "Postinstall"
cp postInstall.sh /mnt/postInstall.sh
chmod 777 /mnt/postInstall.sh
chmod +x /mnt/postInstall.sh

cp postInstallRunner.sh /mnt/postInstallRunner.sh
chmod +x /mnt/postInstallRunner.sh

arch-chroot /mnt /bin/bash postInstallRunner.sh ${username}
rm /mnt/postInstall.sh
rm /mnt/postInstallRunner.sh

echo "DONE ;)"

echo "Now you can reboot to your new system"