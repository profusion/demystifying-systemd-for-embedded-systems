#!/bin/bash

. versions.sh

for s in ${SYSTEMD_BUILDS}; do
    ./systemd-initramfs.sh $s || exit 1
done
