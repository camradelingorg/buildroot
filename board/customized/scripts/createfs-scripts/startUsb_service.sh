#!/bin/bash
TARGET_DIR=${1}
############### usb device otg ##############################################
if [[ -z ${USB_DEVICE_SCRIPT} ]]; then
        rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/startUsb.service > /dev/null 2>&1
        echo "INFO: variable USB_DEVICE_SCRIPT is not set"
elif [[ "${USB_DEVICE_SCRIPT}" == "ON" ]] || [[ "${USB_DEVICE_SCRIPT}" == "on" ]]; then
        rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/startUsb.service > /dev/null 2>&1
        ln -s ../startUsb.service ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/startUsb.service
        echo "INFO: block \"usb device otg\" is ON"
elif    [[ "${USB_DEVICE_SCRIPT}" == "OFF" ]] || [[ "${USB_DEVICE_SCRIPT}" == "off" ]]; then
        rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/startUsb.service > /dev/null 2>&1
	echo "INFO: block \"usb_device_otg\" is OFF"
else
        echo "ERROR: USB_DEVICE_SCRIPT=${USB_DEVICE_SCRIPT}. Only ON or OFF"
        exit 1
fi

