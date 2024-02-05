#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- scsh -e main -s
exit 1

This is a live literate program.

<<prog>>=
(define (main args)
    (display "hello world!\n")
    (display (string-append
        "called with "
        (number->string (length args))
        " args\n"))
    (format #t "args: ~s~%" args))
@
