#!/bin/bash

INSTALLDIR=${1:?missing install dir to strip}

rm -fr $INSTALLDIR/usr/include
rm -fr $INSTALLDIR/usr/lib/pkgconfig
rm -fr $INSTALLDIR/usr/lib/rpm
rm -fr $INSTALLDIR/usr/share/bash-completion
rm -fr $INSTALLDIR/usr/share/doc
rm -fr $INSTALLDIR/usr/share/locale
rm -fr $INSTALLDIR/usr/share/zsh
rm -fr $INSTALLDIR/usr/share/pkgconfig

find $INSTALLDIR -type f -name '*.la' -delete
find $INSTALLDIR -type d -print0 | xargs -0 rmdir 2>/dev/null
find $INSTALLDIR -type f -print0 | xargs -0 strip -s 2>/dev/null

exit 0
