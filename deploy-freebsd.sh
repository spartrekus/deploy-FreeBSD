

echo "** Expert use only"
echo "** Fast deployment, without security at all. no warranty "
echo "** Press Enter"
read abcd

echo Copying mbr with dd...
wget https://raw.githubusercontent.com/spartrekus/deploy-FreeBSD/master/mbr.bin -O mbr.bin
md5 mbr.bin
dd if=mbr.bin of=/dev/da0

gpart list da0

echo Execute newfs on da0s1a
newfs /dev/da0s1a

umount /target
mkdir /target
mount /dev/da0s1a  /target
cd /target


echo Fetching the kernel.txz file
wget "https://netix.dl.sourceforge.net/project/freebsd-12-r328126/r328126-freebsd-dist/usr/freebsd-dist/kernel.txz"    -O kernel.txz 
echo Fetching the base.txz file
wget "https://netcologne.dl.sourceforge.net/project/freebsd-12-r328126/r328126-freebsd-dist/usr/freebsd-dist/base.txz"  -O base.txz 


echo Uncompress kernel file
md5 kernel.txz
tar xpfz kernel.txz

echo Uncompress base file
md5 base.txz 
tar xpfz base.txz

echo Create fstab
echo "/dev/da0s1a     /               ufs     rw      1       1" > /target/etc/fstab 
echo "/dev/da0s1b     none            swap    sw      0       0" >> /target/etc/fstab 


cd /tmp
umount /target
cd /tmp
echo "Mission Completed."
echo "End of Transmission."


