#!/bin/bash
TARGET_DIR=${1}
rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/wpa_supplicant.service
echo "INFO: remove wpa_supplicant service from systemd, it can be added later"
rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/dhclient.service
echo "INFO: remove dhclient service from systemd, it can be added later"
rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/dnsmasq.service
echo "INFO: remove dnsmasq service from systemd, it can be added later"
rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/hostapd.service
echo "INFO: remove hostapd service from systemd, it can be added later"
