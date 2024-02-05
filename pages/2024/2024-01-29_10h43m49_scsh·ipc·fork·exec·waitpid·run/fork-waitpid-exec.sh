#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- scsh -s
exit 1

This is a live literate program.

<<references from fork-waitpid-exec.sh>>=
- `man execve`

@

<<prog>>=
<<show function>>
<<slurp functions>>

(show "(seq 10): " (port->string-list (run/port (seq 10))))
(show "(seq 10): " (run/strings (seq 10)))
(show "(seq 10): " (slurp-to-list '(seq 10)))
(show "(seq 10): " (run/string (seq 10)))
(show "(seq 10): " (slurp-to-string '(seq 10)))

(& (sh -c "sleep 1; date"))

(run (| (seq 100) (perl -lne"$s+=$_}{print$s")))

(exec-epf (date))

(display "Will never happen, due to 'execve' system call above.")
@

<<show function>>=
(define (show p v)
    (format #t "~a~s~%" p v))
@

slurp-to-* uses the procedural equivalent of the special forms run/port and exec-epf

<<slurp functions>>=
(define (slurp-to-string epf)
    (port->string (run/port* (lambda () (apply exec-path epf)))))
(define (slurp-to-list epf)
    (port->string-list (run/port* (lambda () (apply exec-path epf)))))
@
