#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
SH=${SH:-sh -eu}; export SH
AWK=${AWK:-awk}; export AWK
exec nofake-exec.sh --error -Rprog "$@" -- ${SH} -c '
    awkprog=${1}; shift
    thisprog=${1}; shift
    [ -t 0 ] && exec </dev/null
    exec ${AWK} -f "${awkprog}" "$@"
' --
exit 1

This is a live literate program.

<<tested with versions>>=
- awk version 20230911
- mawk 1.3.4 20231126
- GNU Awk 5.1.1, API: 3.1
@

<<try this>>=
seq 3 | ./hello-awk.sh
seq 3 | ./hello-awk.sh - hello-awk.sh
seq 3 | ./hello-awk.sh hello-awk.sh -
seq 3 | AWK=nawk ./hello-awk.sh hello-awk.sh -
seq 3 | AWK=mawk ./hello-awk.sh hello-awk.sh -
@

<<prog>>=
{ print }
END{ print "hello world!" }
