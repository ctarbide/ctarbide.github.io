#!/bin/sh
set -eu; thisprog=$0 aa=
for i; do
    case "${i}" in
        --) aa=${aa:+${aa} }"'--dd--'" ;;
        *) aa=${aa:+${aa} }"'--aa' '${i}'" ;;
    esac
done
eval "set -- ${aa}"
exec nofake-exec.sh --error -Rprog "${thisprog}" "$@" -- scsh -s
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
