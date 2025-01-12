#!/bin/bash
PROCEED=0
ARCHNAME=${1}
ARCHPATH=/media/data/update
if [ ! -f ${ARCHPATH}/${ARCHNAME}.tar.gz ]; then
        echo "no such file: ${ARCHPATH}/${ARCHNAME}.tar.gz"
else
        echo "unpacking $ARCHNAME"
        PROCEED=1
fi
if [ $PROCEED -ne 1 ]; then
	echo "exiting"
        exit 0
fi
if [ -d ${ARCHPATH}/${ARCHNAME} ]; then
        rm -r ${ARCHPATH}/${ARCHNAME}
fi
mkdir ${ARCHPATH}/${ARCHNAME}
RESULT=$(tar xzvf ${ARCHPATH}/${ARCHNAME}.tar.gz -C ${ARCHPATH}/${ARCHNAME})
if [ ! -z ${RESULT} ]; then
        echo "failed to unpack ${ARCHPATH}/${ARCHNAME}.tar.gz"
        exit 0
fi
if [ ! -d /media/boot/updated ]; then
        echo "cant find /media/boot/updated dir, is boot partition mounted?"
        exit 0
fi
echo "${ARCHPATH}/${ARCHNAME}" > /media/boot/needupdate
/root/dropflag.sh
reboot
