#!/bin/bash
set -u
if [[ -z ${KERNEL_IMAGE} ]]; then
        KERNEL_IMAGE=zImage
fi
#copy necessary files
if [[ ! -z ${SRCBOOTINIFILE} && ! -z ${BOOTINIFILE} ]]; then
        cp ${BOARD_DIR}/${SRCBOOTINIFILE} ${BINARIES_DIR}/${SRCBOOTINIFILE}
	mkimage -A arm -O linux -T script -C none -a 0x00000000 -e 0x00000000 -n "boot script" -d ${BINARIES_DIR}/${SRCBOOTINIFILE} ${BINARIES_DIR}/${BOOTINIFILE}
fi
echo -n -e \\x01 > ${BINARIES_DIR}/bootok
if [ ! -d ${BINARIES_DIR}/default ]; then
       mkdir ${BINARIES_DIR}/default
fi
cp ${BINARIES_DIR}/${KERNEL_IMAGE} ${BINARIES_DIR}/default/${KERNEL_IMAGE}
cp ${BINARIES_DIR}/${SRCDTBFILE} ${BINARIES_DIR}/default/${DTBFILE}
echo ${VERSION_TAG} > ${BINARIES_DIR}/default/version.txt
if [ ! -d ${BINARIES_DIR}/updated ]; then
       mkdir ${BINARIES_DIR}/updated
fi
cp ${BINARIES_DIR}/${KERNEL_IMAGE} ${BINARIES_DIR}/updated/${KERNEL_IMAGE}
cp ${BINARIES_DIR}/${SRCDTBFILE} ${BINARIES_DIR}/updated/${DTBFILE}
echo ${VERSION_TAG} > ${BINARIES_DIR}/updated/version.txt
echo ${VERSION_TAG} > ${BINARIES_DIR}/version.txt

if [ ! -d ${BINARIES_DIR}/fakedata ]; then
       mkdir ${BINARIES_DIR}/fakedata
fi
