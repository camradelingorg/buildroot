#!/bin/bash
hexdump /media/boot/bootok | head -n1 | awk '{print $2}' | cut -c 4-
