#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- chibi-scheme
exit 1

This is a live literate program.

<<tested with versions>>=
- chibi-scheme 0.10.0 "neon"
@

<<references>>=
- https://github.com/scheme-requests-for-implementation/srfi-180/blob/master/srfi/run-chibi.sh

- https://github.com/scheme-requests-for-implementation/srfi-180/blob/master/srfi/run-r7rs-checks.scm

@

<<prog>>=
(import (chibi))
; (import (scheme r5rs))
; (import (scheme process-context))
(display "hello world!\n")
