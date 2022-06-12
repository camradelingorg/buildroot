#!/bin/bash
TARGET_DIR=${1}
if [[ -z ${PPPD_SERVICE} ]]; then
        echo "INFO: variable PPPD_SERVICE is not set"
        rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/pppd@1net.service > /dev/null 2>&1
elif [[ "${PPPD_SERVICE}" == "ON" ]] || [[ "${PPPD_SERVICE}" == "on" ]]; then
        rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/pppd@1net.service > /dev/null 2>&1
        if ! [[ ${BOARD_VERSION} == "NKD_V3" ]]; then
		echo "/root/startLte" >> ${TARGET_DIR}/etc/tuning.sh
        fi
	ln -s ../pppd@1net.service ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/pppd@1net.service
        echo "INFO: block \"pppd service\" is ON"
elif [[ "${PPPD_SERVICE}" == "OFF" ]] || [[ "${PPPD_SERVICE}" == "off" ]]; then
        rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/pppd@1net.service > /dev/null 2>&1
	echo "INFO: block \"pppd servce\" is OFF"
else
        echo "ERROR: PPPD_SERVICE=${PPPD_SERVICE}. Only ON or OFF"
        exit 1
fi


