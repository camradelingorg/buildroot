#!/bin/bash
TARGET_DIR=${1}
rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/wpa_supplicant.service
echo "INFO: remove wpa_supplicant service from systemd"
