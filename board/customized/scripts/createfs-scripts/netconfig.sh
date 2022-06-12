#!/bin/bash
TARGET_DIR=${1}
FILENAME="${TARGET_DIR}/etc/network/interfaces"
DNSFILE="${TARGET_DIR}/etc/resolv.conf"

## переменная DEVICE_IFACE берется из vars файла

IFPLUGD_ETH00_SERVICE="${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/ifplugd@${DEVICE_IFACE}.service"
IFPLUGD_ETH01_SERVICE="${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/ifplugd@${DEVICE_IFACE}:1.service"
IFPLUGD_ETH02_SERVICE="${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/ifplugd@${DEVICE_IFACE}:2.service"
IFPLUGD_ETH03_SERVICE="${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/ifplugd@${DEVICE_IFACE}:3.service"
IFPLUGD_ETH04_SERVICE="${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/ifplugd@${DEVICE_IFACE}:4.service"
IFPLUGD_WLAN0_SERVICE="${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/ifplugd@wlan0.service"
# Удаляем все ссылки, которые можем создать (при наличии этих переменных)

if [[ -L "${IFPLUGD_ETH00_SERVICE}" ]]; then
	rm ${IFPLUGD_ETH00_SERVICE}
fi

if [[ -L "${IFPLUGD_ETH01_SERVICE}" ]]; then
	rm ${IFPLUGD_ETH01_SERVICE}
fi

if [[ -L "${IFPLUGD_ETH02_SERVICE}" ]]; then
	rm ${IFPLUGD_ETH02_SERVICE}
fi

if [[ -L "${IFPLUGD_ETH03_SERVICE}" ]]; then
	rm ${IFPLUGD_ETH03_SERVICE}
fi

if [[ -L "${IFPLUGD_ETH04_SERVICE}" ]]; then
	rm ${IFPLUGD_ETH04_SERVICE}
fi

if [[ -L "${IFPLUGD_WLAN0_SERVICE}" ]]; then
        rm ${IFPLUGD_WLAN0_SERVICE}
fi

# рабочий скрипт
if ! [ -d ${TARGET_DIR}/etc/network ]; then
	mkdir ${TARGET_DIR}/etc/network
else
	echo "INFO: folder \"${TARGET_DIR}/etc/network\" exists" 
fi

echo "" > ${FILENAME}
rm ${DNSFILE}
echo "" > ${DNSFILE}
echo "source-directory /etc/network/interfaces.d" >> ${FILENAME}
echo "auto lo" >> ${FILENAME}
echo "iface lo inet loopback" >> ${FILENAME}

if [[ -z "${DEVICE_STATIC_ADDR_ON}" ]]; then
	echo "INFO: variable DEVICE_STATIC_ADDR_ON is not set"
elif [[ "${DEVICE_STATIC_ADDR_ON}" == "false" ]] || [[ "${DEVICE_STATIC_ADDR_ON}" == "FALSE" ]]; then
	echo "INFO: variable DEVICE_STATIC_ADDR_ON=false. STATIC IP is not set"
elif [[ "${DEVICE_STATIC_ADDR_ON}" == "true" ]] || [[ "${DEVICE_STATIC_ADDR_ON}" == "TRUE" ]]; then
	if [[ "${DEVICE_IFACE}" == "eth0" ]]; then
		echo "allow-hotplug eth0" >> ${FILENAME}
		echo "iface eth0 inet static" >> ${FILENAME}
		if [[ ! -z "${DEVICE_STATIC_IPADDR}" ]]; then
			echo " address ${DEVICE_STATIC_IPADDR}" >> ${FILENAME}
			echo "INFO: static address ${DEVICE_STATIC_IPADDR}"
		fi
		if [[ ! -z "${DEVICE_STATIC_NETMASK}" ]]; then
                	echo " netmask ${DEVICE_STATIC_NETMASK}" >> ${FILENAME}
			echo "INFO: static netmask ${DEVICE_STATIC_NETMASK}"
		fi
		if [[ ! -z "${DEVICE_STATIC_GATEWAY}" ]]; then
                	echo " gateway ${DEVICE_STATIC_GATEWAY}" >> ${FILENAME}
			echo "INFO: static gateway ${DEVICE_STATIC_GATEWAY}"
		fi
		ln -s ../ifplugd@.service ${IFPLUGD_ETH00_SERVICE}
	else
		echo "ERROR! script for interface ${DEVICE_IFACE} not work"
		exit 1
	fi
	echo "INFO: \"${FILENAME}\" static done"
else
	echo "ERROR: DEVICE_STATIC_ADDR_ON=${DEVICE_STATIC_ADDR_ON}. Only TRUE or FALSE" 
        exit 1
fi

if [[ -z ${DEVICE_DNS_SERVER} ]]; then
	if [[ -z ${DEVICE_STATIC_GATEWAY} ]]; then
		echo "nameserver 8.8.8.8" >> ${DNSFILE}
		echo "INFO: nameserver 8.8.8.8 done"
	else
		echo "nameserver ${DEVICE_STATIC_GATEWAY}" >> ${DNSFILE}
		echo "nameserver 8.8.8.8" >> ${DNSFILE}
		echo "INFO: nameserver DEVICE_STATIC_GATEWEY=${DEVICE_STATIC_GATEWEY} done"
	fi
else
	echo "nameserver ${DEVICE_DNS_SERVER}" >> ${DNSFILE}
	echo "nameserver 8.8.8.8" >> ${DNSFILE}
	echo "INFO: nameserver DEVICE_DNS_SERVER=${DEVICE_DNS_SERVER} done"
fi

if [[ -z "${DEVICE_DHCP_ADDR_ON}" ]]; then
        echo "INFO: variable DEVICE_DHCP_IPADDR is not set"
elif [[ "${DEVICE_DHCP_ADDR_ON}" == "false" ]] || [[ "${DEVICE_DHCP_ADDR_ON}" == "FALSE" ]]; then
	echo "INFO: variable DEVICE_DHCP_ADDR_on=false. DHCP is not set"
elif [[ "${DEVICE_DHCP_ADDR_ON}" == "true" ]] || [[ "${DEVICE_DHCP_ADDR_ON}" == "TRUE" ]]; then
	if [[ "${DEVICE_IFACE}" == "eth0" ]]; then
		echo "allow-hotplug eth0:1" >> ${FILENAME}
		echo "iface eth0:1 inet dhcp" >> ${FILENAME}
		ln -s ../ifplugd@.service ${IFPLUGD_ETH01_SERVICE}
	fi
	echo "INFO: ${FILENAME} dhcp done"
else
	echo "ERROR: DEVICE_DHCP_ADDR_ON=${DEVICE_DHCP_ADDR_ON}. only TRUE or FALSE"
	exit 1
fi

rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/wpa_supplicant.service
rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/dhclient.service
if [[ ! -z "${WIFI_CLIENT}" ]]; then
	if [ ${WIFI_CLIENT} == "ON" ]; then
		SUPPLICANT_WLAN0_SERVICE="${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/wpa_supplicant.service"
		ln -s ../wpa_supplicant.service ${SUPPLICANT_WLAN0_SERVICE}
		ln -s ../ifplugd@.service ${IFPLUGD_WLAN0_SERVICE}
		SUPPLICANT_CONF_FILE="${TARGET_DIR}/etc/wpa_supplicant.conf"
		echo "ctrl_interface=/var/run/wpa_supplicant" > ${SUPPLICANT_CONF_FILE}
		echo "ap_scan=1" >> ${SUPPLICANT_CONF_FILE}
		echo "network={" >> ${SUPPLICANT_CONF_FILE}
		echo "  key_mgmt=NONE" >> ${SUPPLICANT_CONF_FILE}
		echo "}" >> ${SUPPLICANT_CONF_FILE}
		echo "network={" >> ${SUPPLICANT_CONF_FILE}
		echo "  ssid=\"${WLAN_SSID}\"" >> ${SUPPLICANT_CONF_FILE}
		echo "  key_mgmt=WPA-PSK" >> ${SUPPLICANT_CONF_FILE}
		echo "  psk=\"${WLAN_PSK}\"" >> ${SUPPLICANT_CONF_FILE}
		echo "}" >> ${SUPPLICANT_CONF_FILE}
		############ also add to interfaces file #################
		echo "allow-hotplug wlan0" >> ${FILENAME}
                echo "iface wlan0 inet dhcp" >> ${FILENAME}
	else
		rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/wpa_supplicant.service
		rm ${TARGET_DIR}/etc/wpa_supplicant.conf
	fi
fi

if [[ -z "${ADDITIONAL_STATIC_IPADDR}" ]]; then
        echo "INFO: variable ADDITIONAL_STATIC_IPADDR is not set"
else
	echo "allow-hotplug eth0:2" >> ${FILENAME}
        echo "iface eth0:2 inet static" >> ${FILENAME}
        echo " address ${ADDITIONAL_STATIC_IPADDR}" >> ${FILENAME}
        echo " netmask 255.255.255.0" >> ${FILENAME}
	ln -s ../ifplugd@.service ${IFPLUGD_ETH02_SERVICE}
fi

if [[ -z "${ADDITIONAL_STATIC_IPADDR2}" ]]; then
        echo "INFO: variable ADDITIONAL_STATIC_IPADDR2 is not set"
else
        echo "allow-hotplug eth0:3" >> ${FILENAME}
        echo "iface eth0:3 inet static" >> ${FILENAME}
        echo " address ${ADDITIONAL_STATIC_IPADDR2}" >> ${FILENAME}
        echo " netmask 255.255.255.0" >> ${FILENAME}
	ln -s ../ifplugd@.service ${IFPLUGD_ETH03_SERVICE}
fi

if [[ -z "${ADDITIONAL_STATIC_IPADDR3}" ]]; then
        echo "INFO: variable ADDITIONAL_STATIC_IPADDR3 is not set"
else
        echo "allow-hotplug eth0:4" >> ${FILENAME}
        echo "iface eth0:4 inet static" >> ${FILENAME}
        echo " address ${ADDITIONAL_STATIC_IPADDR3}" >> ${FILENAME}
        echo " netmask 255.255.255.0" >> ${FILENAME}
	ln -s ../ifplugd@.service ${IFPLUGD_ETH00_SERVICE}
fi

exit 0
