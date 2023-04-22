#!/bin/bash
## VARIABLES AND FUNCTIONS ##
source ${PWD}/board/customized/scripts/functions.inc

HOSTNAME_FILE=${TARGET_DIR}/etc/hostname
TARGET_DIR=${1}

delete_file_silent $HOSTNAME_FILE
if [[ -z ${DEV_HOSTNAME} ]]; then
        echo "INFO: variable DEV_HOSTNAME is not set"
else
        set_value $DEV_HOSTNAME $HOSTNAME_FILE
fi
exit 0
