#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- perl -wl
exit 1

This is a live literate program.

<<tested with versions>>=
- This is perl, v5.8.9 built for x86_64-linux
@

<<prog>>=
print "hello world!";
