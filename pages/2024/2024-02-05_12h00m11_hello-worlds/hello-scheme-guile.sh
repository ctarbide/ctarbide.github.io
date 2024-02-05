#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- guile -q --no-auto-compile -s
exit 1

This is a live literate program.

<<tested with versions>>=
- guile (GNU Guile) 2.2.7
@

<<references>>=
- https://github.com/scheme-requests-for-implementation/srfi-180/blob/master/srfi/run-guile.sh

- https://github.com/scheme-requests-for-implementation/srfi-180/blob/master/srfi/run-r7rs-checks.scm

- https://github.com/scheme-requests-for-implementation/srfi-180/blob/master/srfi/run-r7rs-checks.guile.scm

@

<<prog>>=
(display "hello world!\n")
