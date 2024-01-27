#!/bin/sh
exec nofake-exec.sh --error -Rprog "$0" -- scsh -s
exit 1

This is a live literate program.

<<prog>>=
(display "hello world!\n")
@
