#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- scsh -s
exit 1

This is a live literate program.

<<references from run.sh>>=
- https://programmingpraxis.com/contents/standard-prelude/

- https://github.com/scheme/scsh/blob/master/scheme/port-collect.scm

- https://www.scheme.com/tspl4/

- https://ds26gte.github.io/tyscheme/index.html

@

<<prog>>=
(run (seq 3))

(run (begin
    (display 1)(newline)
    (display 2)(newline)
    (display 3)(newline)))

(define (sequence a b)
    (if (<= a b)
        (begin
            (display a)
            (newline)
            (sequence (+ a 1) b))
        (values)))

(sequence 1 3)

(run (begin (sequence 1 3)))

(run (| (seq 100) (perl -lne"$s+=$_}{print$s")))

(run (| (begin (sequence 1 100)) (perl -lne"$s+=$_}{print$s")))

(run (| (begin (sequence 1 100)) (begin (apply exec-path '(perl -lne"$s+=$_}{print$s")))))

(define (fold-left op acc xs)
    (if (null? xs)
        acc
        (fold-left op (op acc (car xs)) (cdr xs))))

(define (sum-slurp)
    (define (read-lines) (port->string-list (current-input-port)))
    (let ((lines (read-lines)))
        (display (fold-left + 0 (map string->number lines)))
        (newline)))

(run (| (begin (sequence 1 100)) (begin (sum-slurp))))

(define (sum-no-slurp)
    (define (doit reader port)
        (let lp ((acc 0))
            (let ((x (reader port)))
                (if (eof-object? x)
                    acc
                    (lp (+ acc (string->number x)))))))
    (display (doit read-line (current-input-port)))
    (newline))

(run (| (begin (sequence 1 100)) (begin (sum-no-slurp))))
@
