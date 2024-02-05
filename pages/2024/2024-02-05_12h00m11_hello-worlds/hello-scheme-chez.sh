#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
CHEZ=${CHEZ:-chez-scheme}; export CHEZ
exec nofake-exec.sh --error -Rprog "$@" -- "${CHEZ}" --script
exit 1

This is a live literate program.

<<tested with versions>>=
- Chez Scheme Version 9.6.4
@

<<tip: how to use alternate program name>>=
CHEZ=scheme ./hello-scheme-chez.sh
@

<<prog>>=
(display "hello world!\n")
