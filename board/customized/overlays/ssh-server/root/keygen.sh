#!/bin/bash
if [ ! -f /etc/ssh/ssh_host_dsa_key ]; then
	ssh-keygen -A
	rsave /etc/ssh/ssh_host_dsa_key
	rsave /etc/ssh/ssh_host_dsa_key.pub
	rsave /etc/ssh/ssh_host_ecdsa_key
    rsave /etc/ssh/ssh_host_ecdsa_key.pub
    rsave /etc/ssh/ssh_host_ed25519_key
    rsave /etc/ssh/ssh_host_ed25519_key.pub
    rsave /etc/ssh/ssh_host_rsa_key
    rsave /etc/ssh/ssh_host_rsa_key.pub
fi
