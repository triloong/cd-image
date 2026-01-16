#!/bin/bash
set -u
set -e
set -o pipefail

if [ $# -lt 2 ]; then
        echo "Usage: $0 variant image_store_dir"
        exit 1
fi

export ARCH=loong64
export DI=trixie
export MIRROR=/srv/repos/mirror
export WDIR=$PWD
export BASEDIR=/usr/share/debian-cd
export CONF=$PWD/CONF.trixie
export CF=$CONF
export ARCHIVE_KEYRING_PACKAGE=debian-loong64-non-official-archive-keyring
export ARCHIVE_KEYRING_FILE=usr/share/keyrings/debian-loong64-non-official-archive-keyring.gpg
export OMIT_DOC_TOOLS=1
VARIANT=$1
export PUBDIRJIG="$2"
export BUILD="$ARCH-$VARIANT"
export SHOW_BUILDS="$BUILD: "
export OUT_FREE_TST=${PUBDIRJIG}
export RELEASE_BUILD=trixie_release
export JIGDOFALLBACKURLS="Debian=http://loong13.debian.net/debian-loong64/"
export IGNORE_DEBUG_SYMBOLS=1

NOCD=
NODVD=
NONI=

. "$VARIANT.cfg"

cd "$BASEDIR" && bash -c '
set -u
set -e
set -o pipefail
mail() {
  echo "$@" >&2
  cat >&2
}
pwd() {
  echo "$WDIR"
}
whoami() {
  echo "nobody"
}
grep() {
  "$(type -f -p grep)" "$@" || :
}
DATE_BUILD=
LOGAPPEND=
DEBIAN_EDU=
OUT_TYPE=
BUILDNAME=
DCD_DIR=$BASEDIR
. contrib/testingcds
' -- "$ARCH"
