#!/bin/bash
/root/setflag.sh
if [ ! -f /media/boot/needupdate ]; then
        exit 0
fi
RAZDEL=$(/root/getrazdel.sh)
if [[ ${RAZDEL} == "work" ]]; then
        echo "needupdate flag set, but rootfs is mounted on work partition. How could that happen? Reboot"
        /root/dropflag.sh
fi
UPDIR=$(cat /media/boot/needupdate)
PARTRE="\/mmcblk([0-9]*)p.*"
ROOTPART=$(lsblk -o NAME,MOUNTPOINT | grep lower | awk '{print $1}')
ROOTPART=/dev/${ROOTPART:2:$((${#ROOTPART}-2))}
if [[ ${ROOTPART} =~ ${PARTRE} ]]; then
        mmcdev=${BASH_REMATCH[1]}
	echo "mmcdev is ${mmcdev}"
else
	mmcdev=0
	echo "default mmcdev is 0"
fi
if [ ! -z $UPDIR ]; then
        /root/reflashfs.sh ${UPDIR} ${mmcdev}
        rm /media/boot/needupdate
        reboot
fi
