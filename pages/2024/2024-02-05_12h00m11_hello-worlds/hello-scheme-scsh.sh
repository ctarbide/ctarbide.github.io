#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- scsh -s
exit 1

This is a live literate program.

<<tested with versions>>=
- scsh 0.7
@

<<prog>>=
(format #t "full args: ~s~%" (command-line))
(format #t "thisprog: ~s~%" (car command-line-arguments))
(format #t "args: ~s~%" (cdr command-line-arguments))
(display "hello world!\n")
