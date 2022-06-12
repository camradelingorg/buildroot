#!/bin/bash
RAZDEL=`lsblk | grep lower | awk '{print $1}' | cut -c 3-`
if [[ ${RAZDEL} == "mmcblk0p3" || ${RAZDEL} == "mmcblk1p3" ]]; then
        echo "work"
elif [[ ${RAZDEL} == "mmcblk0p2" || ${RAZDEL} == "mmcblk1p2" ]]; then
        echo "rezerv"
else
        echo "error"
fi
