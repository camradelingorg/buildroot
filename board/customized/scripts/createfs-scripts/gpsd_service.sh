#!/bin/bash
TARGET_DIR=${1}
#should complete all the variants of serial-getty. It differs from platform to platform
if [[ -z ${GPSD} ]]; then
        echo "INFO: variable GPSD is not set"
        rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/gpsd.service > /dev/null 2>&1
elif [[ "${GPSD}" == "ON" ]] || [[ "${GPSD}" == "on" ]]; then
        rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/gpsd.service > /dev/null 2>&1
        ln -s ../gpsd.service ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/gpsd.service
        if [[ -L ${TARGET_DIR}/etc/systemd/system/getty.target.wants/serial-getty@console.service ]]; then
                rm ${TARGET_DIR}/etc/systemd/system/getty.target.wants/serial-getty@console.service > /dev/null 2>&1
        fi
        echo "INFO: block \"gpsd\" is ON"
elif [[ "${GPSD}" == "OFF" ]] || [[ "${GPSD}" == "off" ]]; then
        rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/gpsd.service > /dev/null 2>&1
        if [[ -L ${TARGET_DIR}/etc/systemd/system/getty.target.wants/serial-getty@console.service ]]; then
                rm ${TARGET_DIR}/etc/systemd/system/getty.target.wants/serial-getty@console.service > /dev/null 2>&1
        fi
        ln -s /lib/systemd/system/serial-getty@.service ${TARGET_DIR}/etc/systemd/system/getty.target.wants/serial-getty@console.service
        echo "INFO: block \"gpsd\" is OFF"
else
        echo "ERROR: GPSD=${GPSD}. Only ON or OFF"
        exit 1
fi
