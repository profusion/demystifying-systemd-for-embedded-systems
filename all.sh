#!/bin/bash

set -xe

./fetch.sh
./extract.sh
./prepare.sh
./compile.sh
./systemd-minimal-strip.sh
./systemd-initramfs-all.sh
./busybox-initramfs.sh
./report.sh
