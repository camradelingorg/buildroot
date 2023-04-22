#!/bin/bash
## VARIABLES AND FUNCTIONS ##
source ${PWD}/board/customized/scripts/functions.inc

TARGET_DIR=${1}

# Удаляем все ссылки, которые могут быть использованы в прошлых сборках
if [[ -L "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/openvpn@client.service" ]]; then
                rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/openvpn@client.service
fi

if [[ -L "${TARGET_DIR}/etc/openvpn/configs/dummy.conf" ]]; then
	rm ${TARGET_DIR}/etc/openvpn/configs/dummy.conf
fi

if [[ -L "${TARGET_DIR}/etc/openvpn/client.conf" ]]; then
	rm ${TARGET_DIR}/etc/openvpn/client.conf
fi

# Если VPN_CONFIG установлен - создаем символическую ссылку на конфиг 
if [[ -z ${VPN_CONFIG} ]]; then
	print_green "INFO: variable VPN_CONFIG is not set"
	exit 0
elif  [[ ! -f ${VPN_CONFIG} ]]; then
	print_red "ERROR: VPN_CONFIG=${VPN_CONFIG}. ERROR! File not found"
	exit 1
else
	cp ${VPN_CONFIG} ${TARGET_DIR}/etc/openvpn/configs/client.conf
	ln -s configs/client.conf ${TARGET_DIR}/etc/openvpn/client.conf
	print_green "INFO: link for configs/client.conf created"
fi

# Если VPN_CLIENT_ON - создаем символическую ссылку на сервис
if [[ -z ${VPN_CLIENT} ]]; then
	print_green "INFO: variable VPN_CLIENT is not set"
	exit 0
elif [[ "${VPN_CLIENT}" == "ON" ]]; then
	ln -s ../openvpn@client.service ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/openvpn@client.service
	print_green "INFO: link for openvpn@client.service created"
	exit 0
elif [[ "${VPN_CLIENT}" == "OFF" ]]; then
	print_green "INFO: VPN_CLIENT is OFF"
else
	print_red "ERROR: VPN_CLIENT=${VPN_CLIENT}. ERROR! only ON or OFF"
	exit 1
fi
exit 0
