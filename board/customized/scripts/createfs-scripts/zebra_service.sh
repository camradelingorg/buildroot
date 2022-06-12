#!/bin/bash
TARGET_DIR=${1}

if [[ -z ${ZEBRA_SERVICE} ]]; then
        rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/zebra.service > /dev/null 2>&1
        echo "INFO: variable ZEBRA_SERVICE is not set"
elif [[ "${ZEBRA_SERVICE}" == "on" ]] || [[ "${ZEBRA_SERVICE}" == "ON" ]]; then
        rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/zebra.service > /dev/null 2>&1
        ln -s ../zebra.service ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/zebra.service
        echo "INFO: block \"zebra service\" is ON"
elif [[ "${ZEBRA_SERVICE}" == "off" ]] || [[ "${ZEBRA_SERVICE}" == "OFF" ]]; then
        rm ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/zebra.service > /dev/null 2>&1
        echo "INFO: block \"zebra service\" is OFF"
else
        echo "ERROR: ZEBRA_SERVICE=${ZEBRA_SERVICE}. Only ON or OFF"
        exit 1
fi
