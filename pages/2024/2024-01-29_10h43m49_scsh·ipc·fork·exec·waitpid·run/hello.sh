#!/bin/sh
exec nofake-exec.sh --error -Rprog "$0" -- scsh -s
exit 1

<<references from hello.sh>>=
- https://www.khoury.northeastern.edu/home/shivers/papers/scsh.pdf

  - [local copy](scsh.pdf)

- https://www.s48.org/1.9.2/manual/manual.html

- https://scsh.net/docu/html/man.html

@

<<prog>>=
(display "hello world!\n")
(run (echo "hello world!"))
(run (/bin/echo "hello world!"))
(run (perl -le"print q{hello world!}"))
(run (perl -le"print 'hello world!'"))
@
