#!/bin/bash
TARGET_DIR=${1}
echo "" >  ${TARGET_DIR}/etc/tuning.vars
if [[ -z ${BOARD_VERSION} ]]; then
	echo "INFO: variable BOARD_VERSION is not set"
else
        echo "BOARD_VERSION=${BOARD_VERSION}" >> ${TARGET_DIR}/etc/tuning.vars
        echo "INFO: variable BOARD_VERSION=${BOARD_VERSION}"
fi
