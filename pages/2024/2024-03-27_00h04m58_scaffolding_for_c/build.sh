#!/bin/sh
# automatically generated from Makefile-wip.nw
set -eu
SH=${SH:-sh -eu}; export SH
nofake --error Makefile-wip.nw | ${SH}
make -f Makefile-wip
