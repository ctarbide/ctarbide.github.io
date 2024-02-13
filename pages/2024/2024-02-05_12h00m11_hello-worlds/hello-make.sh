#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
MAKE=${MAKE:-make}; export MAKE
exec nofake-exec.sh --error -Rprog "$@" -- "${MAKE}" -f
exit 1

This is a live literate program.

<<prog>>=
all:
	@printf -- 'Hello world!\n'
@
