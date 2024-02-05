#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
SH=${SH:-sh}; export SH
exec nofake-exec.sh --error -Rprog "$@" -- "${SH}" -eu -c '
    exec 3<"${0}"
    [ -t 0 ] || perl -lne"}{print(qq{Input discarded, \${.} lines.})"
    exec scheme48 -a batch 0<&3
'
exit 1

This is a live literate program.

<<tested with versions>>=
- Scheme 48 1.9.2
@

AFAIK, Scheme48 only accepts scheme code on standard input, thus the eventual
discarded lines message.

<<try this>>=
seq 10 | ./hello-scheme-scheme48.sh
@

<<prog>>=
(display "hello world!\n")
