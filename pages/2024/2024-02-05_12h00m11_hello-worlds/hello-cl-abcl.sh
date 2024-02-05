#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
ABCL=${ABCL:-abcl.sh}; export ABCL
exec nofake-exec.sh --error -Rprog "$@" -- "${ABCL}" --noinform --batch --load
exit 1

This is a live literate program.

<<tested with versions>>=
- Armed Bear Common Lisp 1.9.2
@

<<see also>>=
- https://github.com/ctarbide/java-scripting

    - provides an `abcl.sh`

@

<<prog>>=
(format t "hello world!~%")
