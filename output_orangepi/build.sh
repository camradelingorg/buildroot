#!/bin/bash
ENVVARS=$1
############ default variable ##########################################
USER=$(ps aux | grep -v grep | grep -m 1 $PWD | awk '{print $1}')
if [ ! -z ${USER} ]; then
        echo "user $USER is already working in this directory"
	exit 0
fi
if [ -z $ENVVARS ]; then
	source default.vars
else
	source $ENVVARS
fi
make
