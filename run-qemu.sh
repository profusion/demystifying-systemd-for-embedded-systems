#!/bin/bash

KERNEL=${1:?missing kernel build to use}
INITRAMFS=${2:?missing initramfs to use}

if [ ! -f $KERNEL -a -f kernel/$KERNEL ]; then
    KERNEL=kernel/$KERNEL
fi

if [ ! -f $INITRAMFS -a -f initramfs/$INITRAMFS.gz ]; then
    INITRAMFS=initramfs/$INITRAMFS.gz
fi

set -xe
exec qemu-system-x86_64 \
     -kernel $KERNEL \
     -initrd $INITRAMFS \
     -nographic -append "console=ttyS0"
