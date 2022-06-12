#!/bin/bash
SCRIPT_DIR="${TARGET_DIR}/../../board/customized/scripts/createfs-scripts"
SCRIPTS=`ls ${SCRIPT_DIR} | grep .*.sh`

for script in ${SCRIPTS}
do
	echo "INFO_FILE: ${script}"
	${SCRIPT_DIR}/${script} "$@"
	echo "######################################################################"
done
