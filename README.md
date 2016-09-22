# Demystifying Systemd for Embedded Systems

This repository contains script used to create the presentation, they are targeted to run on a x86-64 machine that is already prepared to build the Linux Kernel and systemd itself. It was tested solely on ArchLinux.

Scripts:

 - `run-qemu.sh <kernel> <initramfs>` after `./all.sh` is executed, this will allow to boot a virtual machine with kernel and initramfs combinations.
 - `all.sh` run all scripts but `run-qemu.sh`.
 - `fetch.sh` download kernel and systemd source code tarballs. Results in `download/`
 - `extract.sh` unpack kernel and systemd source code tarballs. Results in `src/`
 - `prepare.sh` prepare source to build (`./autogen.sh`).
 - `compile.sh` configure and compile various combinations of kernel and systemd builds. Results in `kernel/` and `systemd/*/install`
 - `systemd-minimal-strip.sh` copy systemd build **easy_diet** and remove some components that cannot be disabled using `./configure --disable-COMPONENT`, such as udev and journal. Results in `systemd/minimal*/install`
 - `systemd-initramfs-all.sh` create initramfs for all systemd builds.
 - `busybox-initramfs.sh` create initramfs for busybox.
 - `report.sh` print out sizes.

Helper Scripts:

 - `systemd-initramfs.sh <build-name>` used by `systemd-initramfs-all.sh` to create initramfs for each build.
 - `systemd-install-strip.sh <systemd-install-dir>` used by `compile.sh` to remove files that doesn't matter, like bash completion, locale and development (includes, pkgconfig)
 - `versions.sh` various defines to be included by other scripts.

Kernel configuration:

 - `kernel-minimal-x86_64.config` config fragment based on **allnoconfig** with minimum requirements to boot busybox. This configuration won't boot systemd.
 - `kernel-systemd-x86_64.config` config fragment to extend `kernel-minimal-x86_64.config` following all https://github.com/systemd/systemd/blob/master/README recommendations. This enables IPv6, namespaces, tmpfs, SECCOMP...
 - `kernel-systemd-minimal-x86_64.config` similar to the previous but instead of enabling everything, enable only the requirements, everything else is left disabled. That is, no IPv4/IPv6, namespaces or SECCOMP.
