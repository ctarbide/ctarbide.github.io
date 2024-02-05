#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
GSI=${GSI:-gsi}; export GSI
exec nofake-exec.sh --error -Rprog "$@" -- "${GSI}"
exit 1

This is a live literate program.

<<tested with versions>>=
- gambit v4.9.5 20230726044844

@

<<references>>=
- http://www.iro.umontreal.ca/~gambit/doc/gambit.html

- http://www.iro.umontreal.ca/~gambit/doc/gambit.pdf

@

<<prog>>=
(display "hello world!\n")
