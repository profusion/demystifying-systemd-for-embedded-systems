#!/bin/bash

set -xe

cd systemd

rm -fr minimal minimal-nojournal minimal-nojournal-noudev

mkdir minimal
cp -a easy-diet/install minimal
pushd minimal/install
# cleanup systemd features not done by ./configure --disable-FEATURE
rm -f  usr/bin/busctl
rm -f  usr/bin/systemd-analyze
rm -f  usr/bin/systemd-cat
rm -f  usr/bin/systemd-cgls
rm -f  usr/bin/systemd-cgtop
rm -f  usr/bin/systemd-delta
rm -f  usr/bin/systemd-detect-virt
rm -f  usr/bin/systemd-escape
rm -f  usr/bin/systemd-machine-id-setup
rm -f  usr/bin/systemd-mount
rm -f  usr/bin/systemd-notify
rm -f  usr/bin/systemd-nspawn
rm -f  usr/bin/systemd-path
rm -f  usr/bin/systemd-run
rm -f  usr/bin/systemd-socket-activate
rm -f  usr/bin/systemd-stdio-bridge

# not doing any kernel install
rm -fr etc/kernel
rm -f  usr/bin/kernel-install
rm -fr usr/lib/kernel

# not doing any of network/resolve, remove leftovers
rm -f  usr/lib/libnss_systemd.so.2
rm -f  usr/lib/systemd/resolv.conf
rm -fr usr/lib/systemd/network

# not doing systemd user sessions or multi-user
rm -fr usr/lib/systemd/system/multi-user.target.wants
rm -f  usr/lib/systemd/system/user@.service
rm -fr usr/lib/systemd/user
rm -fr etc/systemd/system/multi-user.target.wants
rm -f  etc/systemd/user.conf

# not a desktop or desktop:
# no getty, vitual terminal or ctrl-alt-del
rm -f  usr/bin/systemd-ask-password
rm -f  usr/bin/systemd-tty-ask-password-agent
rm -f  usr/lib/systemd/system-generators/systemd-debug-generator
rm -f  usr/lib/systemd/system-generators/systemd-getty-generator
rm -f  usr/lib/systemd/system/autovt@.service
rm -f  usr/lib/systemd/system/console-getty.service
rm -f  usr/lib/systemd/system/console-shell.service
rm -f  usr/lib/systemd/system/container-getty@.service
rm -f  usr/lib/systemd/system/debug-shell.service
rm -f  usr/lib/systemd/system/getty@.service
rm -f  usr/lib/systemd/system/quotaon.service
rm -f  usr/lib/systemd/system/serial-getty@.service
rm -f  usr/lib/systemd/system/sys-fs-fuse-connections.mount
rm -f  usr/lib/systemd/system/sys-kernel-config.mount
rm -f  usr/lib/systemd/system/sys-kernel-debug.mount
rm -f  usr/lib/systemd/system/sysinit.target.wants/sys-fs-fuse-connections.mount
rm -f  usr/lib/systemd/system/sysinit.target.wants/sys-kernel-config.mount
rm -f  usr/lib/systemd/system/sysinit.target.wants/sys-kernel-debug.mount
rm -f  usr/lib/systemd/system/systemd-ask-password-console.path
rm -f  usr/lib/systemd/system/systemd-ask-password-console.service
rm -f  usr/lib/systemd/system/systemd-ask-password-wall.path
rm -f  usr/lib/systemd/system/systemd-ask-password-wall.service
rm -f  usr/lib/systemd/systemd-reply-password

# kexec may be good when you need fast kernel updates, but remove it
rm -f  usr/lib/systemd/system/systemd-kexec.service

# systemd-update system is nice and useful, but is not essential
rm -f  usr/lib/systemd/system/sysinit.target.wants/systemd-update-done.service
rm -f  usr/lib/systemd/system/system-update.target
rm -f  usr/lib/systemd/system/systemd-update-done.service
rm -f  usr/lib/systemd/system-generators/systemd-system-update-generator
rm -f  usr/lib/systemd/systemd-update-done

# systemd-sleep does suspend and hibernation, not essential to some products
rm -f   usr/lib/systemd/systemd-sleep
rm -fr  usr/lib/systemd/system-sleep/
rm -f   usr/lib/systemd/system/systemd-suspend.service

# not doing containers or virtual machines
rm -f  usr/lib/systemd/system/systemd-nspawn@.service
rm -f  usr/lib/systemd/system/local-fs.target.wants/var-lib-machines.mount
rm -f  usr/lib/systemd/system/var-lib-machines.mount

# not doing X11 or XDG
rm -fr etc/xdg
rm -fr etc/X11

# no sysvinit legacy
rm -fr etc/init.d
rm -f  usr/lib/systemd/system-generators/systemd-rc-local-generator
rm -f  usr/lib/systemd/system-generators/systemd-sysv-generator
rm -f  usr/lib/systemd/system/sockets.target.wants/systemd-initctl.socket
rm -f  usr/lib/systemd/system/systemd-initctl.service
rm -f  usr/lib/systemd/system/systemd-initctl.socket
rm -f  usr/lib/systemd/systemd-initctl
rm -f  usr/lib/systemd/systemd/halt-local.service
rm -f  usr/lib/systemd/systemd/rc-local.service

# /etc/fstab is okay, but we can create native systemd.mount
rm -f  usr/lib/systemd/system-generators/systemd-fstab-generator

# we can skip systemd-preset helpers
rm -fr usr/lib/systemd/system-preset
rm -fr usr/share/factory
popd

mkdir minimal-nojournal
cp -a minimal/install minimal-nojournal
pushd minimal-nojournal/install

# saves little, <1Mb
rm -f  etc/systemd/journald.conf
rm -f  usr/bin/journalctl
rm -f  usr/lib/systemd/systemd-journald
rm -f  usr/lib/systemd/system/sockets.target.wants/systemd-journald-audit.socket
rm -f  usr/lib/systemd/system/sockets.target.wants/systemd-journald-dev-log.socket
rm -f  usr/lib/systemd/system/sockets.target.wants/systemd-journald.socket
rm -f  usr/lib/systemd/system/sysinit.target.wants/systemd-journal-catalog-update.service
rm -f  usr/lib/systemd/system/sysinit.target.wants/systemd-journald.service
rm -f  usr/lib/systemd/system/sysinit.target.wants/systemd-journal-flush.service
rm -f  usr/lib/systemd/system/systemd-journal-catalog-update.service
rm -f  usr/lib/systemd/system/systemd-journald-audit.socket
rm -f  usr/lib/systemd/system/systemd-journald-dev-log.socket
rm -f  usr/lib/systemd/system/systemd-journald.service
rm -f  usr/lib/systemd/system/systemd-journald.socket
rm -f  usr/lib/systemd/system/systemd-journal-flush.service
rm -fr usr/lib/systemd/catalog/
rm -fr var/log/
popd

mkdir minimal-nojournal-noudev
cp -a minimal-nojournal/install minimal-nojournal-noudev
pushd minimal-nojournal-noudev/install
# saves little, <3Mb - be aware of dynamic behavior, hotplug and modules
# autoloading will be missed.
rm -fr etc/udev
rm -f  etc/udev/udev.conf
rm -f  usr/bin/udevadm
rm -f  usr/lib/libudev.so*
rm -f  usr/lib/systemd/system/initrd-udevadm-cleanup-db.service
rm -f  usr/lib/systemd/system/sockets.target.wants/systemd-udevd-control.socket
rm -f  usr/lib/systemd/system/sockets.target.wants/systemd-udevd-kernel.socket
rm -f  usr/lib/systemd/system/sysinit.target.wants/systemd-udev-trigger.service
rm -f  usr/lib/systemd/system/sysinit.target.wants/systemd-udevd.service
rm -f  usr/lib/systemd/system/systemd-hwdb-update.service
rm -f  usr/lib/systemd/system/systemd-udev-settle.service
rm -f  usr/lib/systemd/system/systemd-udev-trigger.service
rm -f  usr/lib/systemd/system/systemd-udevd-control.socket
rm -f  usr/lib/systemd/system/systemd-udevd-kernel.socket
rm -f  usr/lib/systemd/system/systemd-udevd.service
rm -f  usr/lib/systemd/systemd-udevd
rm -fr usr/lib/udev
popd
