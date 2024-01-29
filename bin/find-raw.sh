#!/bin/sh
set -eu
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}
PERLPRINT='print(qq{${_}/})}{exit(!$.)' exec "${thisdir}/find.sh" "$@"
