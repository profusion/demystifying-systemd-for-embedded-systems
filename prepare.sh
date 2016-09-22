#!/bin/bash

. versions.sh

set -xe

(cd src/systemd-${SYSTEMD_VERSION} && ./autogen.sh)
