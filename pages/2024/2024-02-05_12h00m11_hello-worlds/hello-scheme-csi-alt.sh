#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- csi -ss
exit 1

This is a live literate program.

<<tested with versions>>=
- Version 5.3.0 (rev e31bbee5)
@

<<references>>=
- https://wiki.call-cc.org/man/5/Using%20the%20interpreter

@

<<prog>>=
(define (main args)
    (display "hello world!\n"))
