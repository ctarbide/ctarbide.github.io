#!/bin/sh
set -eu
SH=${SH:-sh}; export SH
nofake Makefile.nw | "${SH}" > Makefile.wip
make -f Makefile.wip
