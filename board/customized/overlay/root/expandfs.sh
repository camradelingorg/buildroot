#!/bin/bash
MMC=${1}
DATAPART=${2}
echo "resizing data partition of ${MMC}"
echo "data partition number is ${DATAPART}"
if [[ -z ${DATAPART} ]]; then
        echo "no partition with data labeled filesystem"
        exit 1
fi
DATAPART=${DATAPART: -1}
if [ -z ${MMC} ]; then
        MMC=0
fi
fdisk ${MMC} <<EOF
d
${DATAPART}
n



w
EOF
echo "data partition resized"
resize2fs -f ${MMC}p${DATAPART}
e2fsck -f -y ${MMC}p${DATAPART}
echo "data filesystem resized"
