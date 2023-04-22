#!/bin/bash
UPDIR=${1}
MMC=${2}
if [ -z $UPDIR ]; then
	echo "no update path provided"
	exit 1
fi
chown -R root:root ${UPDIR}
mv ${UPDIR}/zImage /media/boot/updated/zImage
echo "zImage updated"
mv ${UPDIR}/*.dtb /media/boot/updated/
echo "dtb files updated"
mv ${UPDIR}/version.txt /media/boot/updated/version.txt
echo "version files updated"
if [ ! -f ${UPDIR}/rootfs.ext2 ]; then
	echo "no rootfs image provided"
	exit 2
fi
if [ -z ${MMC} ]; then
	MMC=0
fi
dd if=${UPDIR}/rootfs.ext2 of=/dev/mmcblk${MMC}p3 bs=1M
echo "rootfs image updated"
/root/setflag.sh
echo "bootflag set"
rm -r ${UPDIR}
exit 0
