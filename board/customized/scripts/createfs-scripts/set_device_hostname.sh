#!/bin/bash
TARGET_DIR=${1}

if [[ -z ${DEV_HOSTNAME} ]]; then
        echo "INFO: variable DEV_HOSTNAME is not set"
else
        echo ${DEV_HOSTNAME} > ${TARGET_DIR}/etc/hostname
        echo "INFO: variable DEV_HOSTNAME=${DEV_HOSTNAME}"
fi
