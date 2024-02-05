#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" -e bye --ea--
exec nofake-exec.sh --error -Rprog "$@" -- gforth
exit 1

This is a live literate program.

<<tested with versions>>=
- gforth 0.7.3
@

<<references>>=
- https://gforth.org/manual/Using-files-for-Forth-code-Tutorial.html

@

<<prog>>=
." hello world!" cr
