#!/bin/bash
source ${PWD}/board/customized/scripts/functions.inc

STARTUSB_FILE=../startUsb.service
STARTUSB_LINK=${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/startUsb.service
TARGET_DIR=${1}

## start

delete_file_silent $STARTUSB_LINK
############### usb device otg ##############################################
if [[ -z ${USB_DEVICE_SCRIPT} ]] || [[ "${USB_DEVICE_SCRIPT}" == "OFF" ]]; then
        print_red "INFO: startUsb.service is OFF"
elif [[ "${USB_DEVICE_SCRIPT}" == "ON" ]]; then
        create_link $STARTUSB_FILE $STARTUSB_LINK
        print_green "INFO: block \"usb device otg\" is ON"
else
        print_red "ERROR: USB_DEVICE_SCRIPT=${USB_DEVICE_SCRIPT}. Only ON or OFF"
        exit 2
fi

