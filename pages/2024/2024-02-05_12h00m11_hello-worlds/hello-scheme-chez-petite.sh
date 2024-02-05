#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
CHEZ=${CHEZ:-petite}; export CHEZ
exec nofake-exec.sh --error -Rprog "$@" -- "${CHEZ}" --script
exit 1

This is a live literate program.

<<tested with versions>>=
- Petite Chez Scheme Version 9.6.4
@

<<prog>>=
(display "hello world!\n")
