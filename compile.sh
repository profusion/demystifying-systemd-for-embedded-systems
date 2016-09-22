#!/bin/bash

. versions.sh

BASEDIR=$PWD

rm -fr kernel
mkdir kernel
pushd kernel

set -xe

mkdir -p kernel/x86_64_defconfig
pushd ${BASEDIR}/src/linux-${KERNEL_VERSION}

make x86_64_defconfig

make
cp -a `make -s image_name` ${BASEDIR}/kernel/x86_64_defconfig
popd


mkdir -p kernel/minimal
pushd ${BASEDIR}/src/linux-${KERNEL_VERSION}

make allnoconfig
scripts/kconfig/merge_config.sh -m .config ${BASEDIR}/kernel-minimal-x86_64.config
yes "" | make oldconfig

make
cp -a `make -s image_name` ${BASEDIR}/kernel/minimal
popd


mkdir -p kernel/systemd
pushd ${BASEDIR}/src/linux-${KERNEL_VERSION}

make allnoconfig
scripts/kconfig/merge_config.sh -m .config ${BASEDIR}/kernel-minimal-x86_64.config
scripts/kconfig/merge_config.sh -m .config ${BASEDIR}/kernel-systemd-x86_64.config
yes "" | make oldconfig

make
cp -a `make -s image_name` ${BASEDIR}/kernel/systemd
popd

mkdir -p kernel/systemd-minimal
pushd ${BASEDIR}/src/linux-${KERNEL_VERSION}

make allnoconfig
scripts/kconfig/merge_config.sh -m .config ${BASEDIR}/kernel-minimal-x86_64.config
scripts/kconfig/merge_config.sh -m .config ${BASEDIR}/kernel-systemd-minimal-x86_64.config
yes "" | make oldconfig

make
cp -a `make -s image_name` ${BASEDIR}/kernel/systemd-minimal
popd


popd

rm -fr systemd
mkdir systemd
pushd systemd

mkdir -p vanilla/build
pushd vanilla/build
${BASEDIR}/src/systemd-${SYSTEMD_VERSION}/configure \
    CFLAGS="-O2 -ftrapv" \
    --sysconfdir=/etc \
    --localstatedir=/var \
    --libdir=/usr/lib \
    --disable-manpages \
    --disable-ldconfig \
    --disable-tests
make
make install DESTDIR=$PWD/../install
${BASEDIR}/systemd-install-strip.sh $PWD/../install
popd


mkdir -p easy-diet/build
pushd easy-diet/build
${BASEDIR}/src/systemd-${SYSTEMD_VERSION}/configure \
    CFLAGS="-Os -ftrapv" \
    --disable-nls \
    --disable-dbus \
    --disable-utmp \
    --disable-kmod \
    --disable-xkbcommon \
    --disable-blkid \
    --disable-seccomp \
    --disable-ima \
    --disable-selinux \
    --disable-apparmor \
    --disable-adm \
    --disable-wheel \
    --disable-xz \
    --disable-zlib \
    --disable-lz4 \
    --disable-pam \
    --disable-acl \
    --disable-smack \
    --disable-gcrypt \
    --disable-audit \
    --disable-elfutils \
    --disable-libcryptsetup \
    --disable-qrencode \
    --disable-gnutls \
    --disable-microhttpd \
    --disable-libcurl \
    --disable-libidn \
    --disable-libiptc \
    --disable-binfmt \
    --disable-vconsole \
    --disable-quotacheck \
    --disable-tmpfiles \
    --disable-sysusers \
    --disable-firstboot \
    --disable-randomseed \
    --disable-backlight \
    --disable-rfkill \
    --disable-logind \
    --disable-machined \
    --disable-importd \
    --disable-hostnamed \
    --disable-timedated \
    --disable-timesyncd \
    --disable-localed \
    --disable-coredump \
    --disable-polkit \
    --disable-resolved \
    --disable-networkd \
    --disable-efi \
    --disable-gnuefi \
    --disable-tpm \
    --disable-myhostname \
    --disable-hwdb \
    --disable-manpages \
    --disable-hibernate \
    --disable-ldconfig \
    --disable-tests \
    --with-sysvrcnd-path=  \
    --with-sysvinit-path=
make
make install DESTDIR=$PWD/../install
${BASEDIR}/systemd-install-strip.sh $PWD/../install
popd

popd
