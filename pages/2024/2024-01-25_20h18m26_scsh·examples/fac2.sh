#!/bin/sh
# https://ctarbide.github.io/pages/2024/TBD_hello-worlds
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- scsh -s
exit 1

This is a live literate program.

<<references>>=
- <https://en.wikibooks.org/wiki/Scheme_Programming/Looping>
@

<<prog>>=
(define (! n)
    (if (= n 0)
        1
        (* n (! (- n 1)))))
(format #t "~s~%" (! 5))
@
