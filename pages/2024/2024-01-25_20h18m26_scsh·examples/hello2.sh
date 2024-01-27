#!/bin/sh
set -eu; thisprog=$0 aa=
for i; do
    case "${i}" in
        --) aa=${aa:+${aa} }"'--dd--'" ;;
        *) aa=${aa:+${aa} }"'--aa' '${i}'" ;;
    esac
done
eval "set -- ${aa}"
exec nofake-exec.sh --error -Rprog "${thisprog}" "$@" -- scsh -e main -s
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
