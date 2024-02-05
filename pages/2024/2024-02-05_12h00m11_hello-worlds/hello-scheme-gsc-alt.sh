#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
set -- "$@" --tmp-- .out
SH=${SH:-sh}
GSC=${GSC:-gambit-gsc}
export SH GSC
exec nofake-exec.sh --error -Rprog "$@" -- "${SH}" -eu -c '
    "${GSC}" -exe -o "${0}.out" "${0}"
    exec "${0}.out" "$@"
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
GSC=gsc ./hello-scheme-gsc-alt.sh
@

<<prog>>=
(display "hello world!\n")
