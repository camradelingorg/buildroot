#!/bin/bash
source /etc/ifplugd.vars
if [ ! -z $BLOHA_SUBNET ]; then
	route add -net $BLOHA_SUBNET eth0
fi
exit 0
