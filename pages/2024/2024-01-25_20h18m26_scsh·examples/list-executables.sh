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
(define (executables dir)
  (with-cwd dir
    (filter file-executable? (directory-files dir #t))))
(define (writeln x) (display x) (newline))
(for-each writeln
  (append-map executables ((infix-splitter ":") (getenv "PATH"))))
@
