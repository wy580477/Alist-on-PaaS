#!/bin/sh

set -e
DIR_TMP="$(mktemp -d)"

# Install alist
wget -O - https://github.com/alist-org/alist/releases/latest/download/alist-linux-musl-amd64.tar.gz | tar -zxf - -C ${DIR_TMP}
install -m 755 ${DIR_TMP}/alist /usr/bin/

# Install Aria2
wget -O - https://github.com/P3TERX/Aria2-Pro-Core/releases/download/1.36.0_2021.08.22/aria2-1.36.0-static-linux-amd64.tar.gz | tar -zxf - -C /usr/bin

rm -rf ${DIR_TMP}
