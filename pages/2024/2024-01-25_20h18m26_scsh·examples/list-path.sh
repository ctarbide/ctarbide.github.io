#!/bin/sh
# https://ctarbide.github.io/pages/2024/TBD_hello-worlds
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- scsh -s
exit 1

This is a live literate program.

<<references>>=
- <https://en.wikipedia.org/wiki/Scsh>
@

<<original snippet>>=
#!/usr/local/bin/scsh -s
!#

(define (executables dir)
  (with-cwd dir
    (filter file-executable? (directory-files dir #t))))
(define (writeln x) (display x) (newline))

(for-each writeln
  (append-map executables ((infix-splitter ":") (getenv "PATH"))))
@

<<prog>>=
(define (writeln x) (display x) (newline))
(for-each writeln ((infix-splitter ":") (getenv "PATH")))
@

<<perl one-liner>>=
perl -le'print for split(q{:},$ENV{PATH})'
@
