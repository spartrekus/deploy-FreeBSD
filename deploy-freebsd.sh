


echo =========================
echo "** Expert use only"
echo "** Fast deployment, without security at all. no warranty "
echo "** Press Enter"
echo =========================
echo disks
  gpart show | grep da0 
ls /dev/da0* 
echo =========================
mount | grep da0 
echo =========================
echo ==Please Enter to Cont ==
echo =========================
read abcd

cp deploy-freebsd.sh  /root/deploy-freebsd.sh 



pkg install -y wget 

echo "MD5 kernel.txz = 0d4ed395541dbeb6ae9001afc351561e"
echo "MD5 base.txz = 97216020220a816ab689b6ee25bbbd9e"
echo "MD5 mbr.bin = be7329a1dfff69930ae2c8b12f2a0b6f"




echo Copying mbr with dd...
pwd

wget    --no-check-certificate   https://raw.githubusercontent.com/spartrekus/deploy-FreeBSD/master/mbr.bin -O         /tmp/mbr.bin  

md5 /tmp/mbr.bin
dd if=/tmp/mbr.bin of=/dev/da0

gpart list da0

echo =========================
echo Execute newfs on da0s1a
newfs /dev/da0s1a

cd /tmp
umount /target
mkdir /target
mount /dev/da0s1a  /target
cd /target
pwd
echo =========================
echo mounted
mount | grep da0 
echo =========================
pwd


echo =========================
echo Fetching the kernel.txz file
pwd
wget  --no-check-certificate    "https://netix.dl.sourceforge.net/project/freebsd-12-r328126/r328126-freebsd-dist/usr/freebsd-dist/kernel.txz"    -O kernel.txz 

echo Fetching the base.txz file
pwd
wget  --no-check-certificate      "https://netcologne.dl.sourceforge.net/project/freebsd-12-r328126/r328126-freebsd-dist/usr/freebsd-dist/base.txz"  -O base.txz 


wget --no-check-certificate "https://raw.githubusercontent.com/spartrekus/freebsd-13-entropyfix/master/MANIFEST"     -O MANIFEST   




echo =========================
echo Uncompress kernel file
md5 kernel.txz
tar xpfz kernel.txz

echo =========================
echo Uncompress base file
md5 base.txz 
tar xpfz base.txz


echo =========================
echo Copy packages base and kernel to install later
#cp base.txz    /target/usr/freebsd-dist/base.txz  
#cp kernel.txz  /target/usr/freebsd-dist/kernel.txz 
#cp MANIFEST  /target/usr/freebsd-dist/MANIFEST  
echo manifest would be useful to be there
echo you can run later bsdinstall 


echo =========================
echo Create fstab
echo "/dev/da0s1a     /               ufs     rw      1       1" > /target/etc/fstab 
echo "/dev/da0s1b     none            swap    sw      0       0" >> /target/etc/fstab 



echo =========================
echo Create directories
mkdir  /target/usr/
mkdir  /target/usr/freebsd-dist/ 
mkdir  /target/usr/local/
mkdir  /target/usr/local/bin/ 


echo =========================
echo Entropy fix wrapper for lib
echo you will need libcrypto.so.111 into /lib 
echo you will need libssl.so.111    into /lib 
echo =========================
echo Copy wrapper
cat     /root/bsd/rc.conf >>  /target/etc/rc.conf 
cp      /root/bsd/wpa*        /target/etc/   
cp  -r  /root/freebsd-dist/   /target/usr/freebsd-dist/ 
cp      /root/bsd/nconfig     /target/usr/local/bin
cp      /root/bsd/nswiss      /target/usr/local/bin
cp      /root/bsd/libcrypto.so.111    /target/lib/ 
cp      /root/bsd/libssl.so.111       /target/lib/ 
echo you will need libcrypto.so.111 into /lib 
echo you will need libssl.so.111    into /lib 
echo =========================
cp -r   /root/bsd/               /target/root/bsd/  
cp  -r  /root/freebsd-dist/      /target/root/freebsd-dist/ 
cp      /root/deploy-freebsd.sh  /target/root/deploy-freebsd.sh     




echo =========================
echo Process umount
echo =========================

echo Umount
cd /tmp
umount /target
umount /target
cd /tmp
mount

echo =========================
echo Process Completed
echo =========================

echo =========================
echo "Mission Completed."
echo "End of Transmission."
echo =========================

