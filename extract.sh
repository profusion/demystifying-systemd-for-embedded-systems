#!/bin/bash

. versions.sh

rm -fr src
mkdir src
cd src

set -xe

tar xJf ../download/linux-${KERNEL_VERSION}.tar.xz
tar xzf ../download/systemd-${SYSTEMD_VERSION}.tar.gz
