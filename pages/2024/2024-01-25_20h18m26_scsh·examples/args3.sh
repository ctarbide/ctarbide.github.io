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
- <https://scsh.net/docu/post/signall.html>
- <https://en.wikibooks.org/wiki/Scheme_Programming/Looping>
@

<<prog>>=
(define argc (length command-line-arguments))
(define (show v)
    (display v)
    (newline))
(define (show-args n)
    (define (loop i)
        (if (<= i n)
            (begin
                (format #t "argv ~a: ~s~%" i (argv i))
                (loop (+ i 1)))
            #f))
    (loop 1))
(show argc)
(show (argv 0))
(show-args argc)
@
