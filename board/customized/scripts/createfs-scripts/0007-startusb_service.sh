#!/bin/bash
## VARIABLES AND FUNCTIONS ##
source ${PWD}/board/customized/scripts/functions.inc

TARGET_DIR=${1}

## start
sed -i -E "s/export USB_GADGET_DEVICE=.*/export USB_GADGET_DEVICE=${USB_GADGET_DEVICE}/g" ${TARGET_DIR}/${SYSTEM_VARS_FILE}
print_green "USB_GADGET_DEVICE=${USB_GADGET_DEVICE}"
sed -i -E "s/export USB_RNDIS=.*/export USB_RNDIS=${USB_RNDIS}/g" ${TARGET_DIR}/${SYSTEM_VARS_FILE}
print_green "USB_RNDIS=${USB_RNDIS}"
sed -i -E "s/export USB_MASS_STORAGE=.*/export USB_MASS_STORAGE=${USB_MASS_STORAGE}/g" ${TARGET_DIR}/${SYSTEM_VARS_FILE}
print_green "USB_MASS_STORAGE=${USB_MASS_STORAGE}"

