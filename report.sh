#!/bin/bash

. versions.sh

echo "kernel sizes:"
for k in ${KERNEL_BUILDS}; do
    echo "   $k: `du -h kernel/$k | cut -f1`"
done

echo
echo "systemd sizes:"
for s in ${SYSTEMD_BUILDS}; do
    echo "  $s: `du -hs systemd/$s/install | cut -f1`"
    if [ ${s/-nojournal/} = $s ]; then
        echo -n "    journal: "
        (cd systemd/$s/install && \
             du -hcs \
                etc/systemd/journald.conf \
                usr/bin/journalctl \
                usr/lib/systemd/systemd-journald \
                usr/lib/systemd/system/sockets.target.wants/systemd-journald-audit.socket \
                usr/lib/systemd/system/sockets.target.wants/systemd-journald-dev-log.socket \
                usr/lib/systemd/system/sockets.target.wants/systemd-journald.socket \
                usr/lib/systemd/system/sysinit.target.wants/systemd-journal-catalog-update.service \
                usr/lib/systemd/system/sysinit.target.wants/systemd-journald.service \
                usr/lib/systemd/system/sysinit.target.wants/systemd-journal-flush.service \
                usr/lib/systemd/system/systemd-journal-catalog-update.service \
                usr/lib/systemd/system/systemd-journald-audit.socket \
                usr/lib/systemd/system/systemd-journald-dev-log.socket \
                usr/lib/systemd/system/systemd-journald.service \
                usr/lib/systemd/system/systemd-journald.socket \
                usr/lib/systemd/system/systemd-journal-flush.service \
                usr/lib/systemd/catalog/ \
                var/log/ \
                2>/dev/null | tail -1 | cut -f1)
    fi
    if [ ${s/-noudev/} = $s ]; then
        echo -n "    udev: "
        (cd systemd/$s/install &&
             du -hcs \
                etc/udev \
                etc/udev/udev.conf \
                usr/bin/udevadm \
                usr/lib/libudev.so* \
                usr/lib/systemd/system/initrd-udevadm-cleanup-db.service \
                usr/lib/systemd/system/sockets.target.wants/systemd-udevd-control.socket \
                usr/lib/systemd/system/sockets.target.wants/systemd-udevd-kernel.socket \
                usr/lib/systemd/system/sysinit.target.wants/systemd-udev-trigger.service \
                usr/lib/systemd/system/sysinit.target.wants/systemd-udevd.service \
                usr/lib/systemd/system/systemd-hwdb-update.service \
                usr/lib/systemd/system/systemd-udev-settle.service \
                usr/lib/systemd/system/systemd-udev-trigger.service \
                usr/lib/systemd/system/systemd-udevd-control.socket \
                usr/lib/systemd/system/systemd-udevd-kernel.socket \
                usr/lib/systemd/system/systemd-udevd.service \
                usr/lib/systemd/systemd-udevd \
                usr/lib/udev \
                2>/dev/null | tail -1 | cut -f1)
    fi
done

echo "initramfs.gz sizes (including copied host libraries!):"
    echo "  busybox: `du -hs initramfs/busybox.gz | cut -f1`"
for i in ${SYSTEMD_BUILDS}; do
    echo "  $i: `du -hs initramfs/systemd-$i.gz | cut -f1`"
done
