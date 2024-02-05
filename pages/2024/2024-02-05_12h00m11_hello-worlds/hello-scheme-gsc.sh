#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
set -- "$@" --tmp-- .o1
SH=${SH:-sh}
GSC=${GSC:-gambit-gsc}
GSI=${GSI:-gsi}
export SH GSC GSI
exec nofake-exec.sh --error -Rprog "$@" -- "${SH}" -eu -c '
    "${GSC}" -o "${0}.o1" "${0}"
    exec "${GSI}" "${0}.o1" "$@"
'
exit 1

This is a live literate program.

<<tested with versions>>=
- Gambit v4.9.5 20230726044844

@

<<references>>=
- https://www.gambitscheme.org/latest/manual/#GSC

- https://www.gambitscheme.org/latest/manual/#Compiling-scripts

@

<<tip: how to use alternate program name>>=
GSC=gsc ./hello-scheme-gsc.sh
@

<<prog>>=
(display "hello world!\n")
