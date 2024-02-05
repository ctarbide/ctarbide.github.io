#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- scsh -s
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
            (values)))
    (loop 1))
(show argc)
(show (argv 0))
(show-args argc)
@
