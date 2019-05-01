#.1
#.2
#.3
#.4
echo =========================
echo "** Expert use only"
echo "** Fast deployment, without security at all. no warranty "
echo "** Press Enter"
echo =========================
read abcd


pkg install -y wget 

echo "MD5 kernel.txz = 0d4ed395541dbeb6ae9001afc351561e"
echo "MD5 base.txz = 97216020220a816ab689b6ee25bbbd9e"
echo "MD5 mbr.bin = be7329a1dfff69930ae2c8b12f2a0b6f"

echo Copying mbr with dd...
pwd
wget   --no-check-certificate   https://raw.githubusercontent.com/spartrekus/deploy-FreeBSD/master/mbr.bin -O mbr.bin
md5 mbr.bin
dd if=mbr.bin of=/dev/da0

gpart list da0

echo =========================
echo Execute newfs on da0s1a
newfs /dev/da0s1a

cd /tmp
umount /target
mkdir /target
mount /dev/da0s1a  /target
cd /target


echo =========================
echo Fetching the kernel.txz file
pwd
wget   --no-check-certificate     "https://netix.dl.sourceforge.net/project/freebsd-12-r328126/r328126-freebsd-dist/usr/freebsd-dist/kernel.txz"    -O kernel.txz 

echo Fetching the base.txz file
pwd
wget    --no-check-certificate    "https://netcologne.dl.sourceforge.net/project/freebsd-12-r328126/r328126-freebsd-dist/usr/freebsd-dist/base.txz"  -O base.txz 


echo =========================
echo Uncompress kernel file
md5 kernel.txz
tar xpfz kernel.txz

echo =========================
echo Uncompress base file
md5 base.txz 
tar xpfz base.txz

echo =========================
echo Create fstab
echo "/dev/da0s1a     /               ufs     rw      1       1" > /target/etc/fstab 
echo "/dev/da0s1b     none            swap    sw      0       0" >> /target/etc/fstab 



echo =========================
echo Create rc.conf and wifi wpa config using local etc directory
cp /etc/rc.conf /target/etc/rc.conf
cp /etc/wpa_supplicant.conf /target/etc/


echo =========================
echo Copy wrapper

mkdir /target/usr/local/bin
cp /usr/local/bin/nconfig  /target/usr/local/bin
cp /usr/local/bin/nswiss   /target/usr/local/bin

echo =========================
echo Entropy fix wrapper for lib
cp /root/libcrypto.so.111  /target/root/
cp /root/libssl.so.111     /target/root/ 


  cd /root 
  fetch -R https://raw.githubusercontent.com/spartrekus/freebsd-13-entropyfix/master/libssl.so.111  
  fetch  -R https://raw.githubusercontent.com/spartrekus/freebsd-13-entropyfix/master/libcrypto.so.111 


echo =========================
echo Process Completed

echo Umount
cd /tmp
umount /target
umount /target
cd /tmp
mount

echo =========================
 date 
echo =========================
echo "Mission Completed."
echo "End of Transmission."
echo =========================



