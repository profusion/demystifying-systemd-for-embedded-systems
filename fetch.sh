#!/bin/bash

. versions.sh

rm -fr download
mkdir download
cd download

set -xe

echo "download linux-${KERNEL_VERSION}"
curl -L https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${KERNEL_VERSION}.tar.xz -o linux-${KERNEL_VERSION}.tar.xz.partial

mv linux-${KERNEL_VERSION}.tar.xz.partial linux-${KERNEL_VERSION}.tar.xz

echo "download systemd-${SYSTEMD_VERSION}"
curl -L https://github.com/systemd/systemd/archive/v${SYSTEMD_VERSION}.tar.gz -o systemd-${SYSTEMD_VERSION}.tar.gz.partial

mv systemd-${SYSTEMD_VERSION}.tar.gz.partial systemd-${SYSTEMD_VERSION}.tar.gz
