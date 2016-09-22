#!/bin/bash

which ldd >/dev/null || exit 1
which cpio >/dev/null || exit 1
which readlink >/dev/null || exit 1
which gzip >/dev/null || exit 1
which busybox >/dev/null || exit 1

SYSTEMD_BUILD=${1:?missing systemd build name}
INSTALLDIR=systemd/${SYSTEMD_BUILD}/install

cp_deps() {
    LD_LIBRARY_PATH=./usr/lib ldd "$1" 2>&1 | grep -e '=>' | sed -e 's/^.* => \([^ ]\+\).*$/\1/g' \
        | while read f; do
        if [ ! -e "./$f" ]; then
            dname=`dirname $f`
            mkdir -p "./$dname"
            echo "cp dep $f of $1"
            cp -a "$f" "./$f"

            if [ -h "$f" ]; then
                target=`readlink $f`
                if [ ! -e "$target" ]; then
                   target="$dname/$target"
                fi
                mkdir -p ./`dirname $target`
                echo "cp symlink target $target"
                cp -a "$target" "./$target"
                cp_deps "./$target"
            fi
            cp_deps "./$f"
        fi
    done
}

rm -fr initramfs/systemd-${SYSTEMD_BUILD}
mkdir -p initramfs/systemd-${SYSTEMD_BUILD}
cp -a $INSTALLDIR/* initramfs/systemd-${SYSTEMD_BUILD}/
pushd initramfs/systemd-${SYSTEMD_BUILD}/

# prepare FS structure
mkdir -p etc dev proc sys tmp root usr/lib usr/bin var
ln -sf usr/bin bin
ln -sf usr/bin sbin
ln -sf usr/lib lib
ln -sf usr/lib lib64

ln -sf ../proc/self/mounts etc/mtab
ln -sf usr/lib/systemd/systemd init

cp -a /lib/ld-linux-x86-64.so.2 ./lib/ld-linux-x86-64.so.2
cp -a /lib/`readlink /lib/ld-linux-x86-64.so.2` ./lib

echo test-system > etc/hostname
cat <<EOF > etc/os-release
NAME="Test Systemd"
PRETTY_NAME="Test Systemd"
ID=test
EOF

cat <<EOF > etc/passwd
root::0:0:root:/root:/bin/sh
bin:x:1:1:bin:/bin:/usr/bin/nologin
daemon:x:2:2:daemon:/:/usr/bin/nologin
mail:x:8:12:mail:/var/spool/mail:/usr/bin/nologin
ftp:x:14:11:ftp:/srv/ftp:/usr/bin/nologin
http:x:33:33:http:/srv/http:/usr/bin/nologin
uuidd:x:68:68:uuidd:/:/usr/bin/nologin
dbus:x:81:81:dbus:/:/usr/bin/nologin
nobody:x:99:99:nobody:/:/usr/bin/nologin
EOF
chmod 644 etc/passwd

cat <<EOF > etc/group
root:x:0:root
bin:x:1:root,bin,daemon
daemon:x:2:root,bin,daemon
sys:x:3:root,bin
adm:x:4:root,daemon
tty:x:5:
disk:x:6:root
lp:x:7:daemon
mem:x:8:
kmem:x:9:
wheel:x:10:root
ftp:x:11:
mail:x:12:
uucp:x:14:
log:x:19:root
utmp:x:20:
locate:x:21:
rfkill:x:24:
smmsp:x:25:
proc:x:26:
http:x:33:
games:x:50:
lock:x:54:
uuidd:x:68:
dbus:x:81:
network:x:90:
video:x:91:
audio:x:92:
optical:x:93:
floppy:x:94:
storage:x:95:
scanner:x:96:
input:x:97:
power:x:98:
nobody:x:99:
EOF
chmod 644 etc/group

# our app is busybox's sulogin, shame on me
cp -a /usr/bin/busybox ./usr/bin/busybox
/usr/bin/busybox --list | while read f; do
    ln -sf busybox ./usr/bin/$f
done
cat <<EOF > usr/lib/systemd/system/myapp.service
[Unit]
Description=My App (/bin/sulogin)
Conflicts=shutdown.target
Before=shutdown.target

[Service]
Environment=HOME=/root
WorkingDirectory=/root
ExecStart=/bin/sulogin
Type=idle
StandardInput=tty-force
StandardOutput=inherit
StandardError=inherit
KillMode=process
IgnoreSIGPIPE=no
SendSIGHUP=yes
Restart=always

[Install]
WantedBy=basic.target
EOF
ln -sf basic.target usr/lib/systemd/system/default.target
mkdir usr/lib/systemd/system/basic.target.wants
ln -sf ../myapp.service usr/lib/systemd/system/basic.target.wants/myapp.service

# copy dependencies and generate initramfs
find . -type f | while read f; do
    cp_deps "$f"
done
find . -print0 | cpio --null --owner=root:root -o --format=newc | gzip -9 > ../systemd-${SYSTEMD_BUILD}.gz

popd
sync
du -hs initramfs/systemd-${SYSTEMD_BUILD}.gz initramfs/systemd-${SYSTEMD_BUILD}
