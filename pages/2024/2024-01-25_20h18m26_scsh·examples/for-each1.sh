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
(define argc (length command-line-arguments))
(format #t "argc: ~a~%" argc)
(format #t "args: ~s~%" command-line-arguments)
(for-each (lambda (arg)
    (format #t "arg: ~s~%" arg))
    command-line-arguments)
@
