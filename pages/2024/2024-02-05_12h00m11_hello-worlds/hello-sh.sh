#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
SH=${SH:-sh}; export SH
exec nofake-exec.sh --error -Rprog "$@" -- "${SH}" -eu
exit 1

This is a live literate program.

<<tested with versions>>=
- dash 0.5.12
- mksh R59c
- zsh 5.9_3
- ksh 1.0.8
@

<<references>>=
- https://mywiki.wooledge.org/Bashism

- https://stackoverflow.com/questions/5725296/difference-between-sh-and-bash

@

No bashism, please, see references.

<<try this>>=
./hello-sh.sh a "b c" ' ${d} '
SH=dash mksh -x ./hello-sh.sh a "b c" ' ${d} '
SH=mksh dash -x ./hello-sh.sh a "b c" ' ${d} '
SH=zsh ./hello-sh.sh a "b c" ' ${d} '
SH=ksh ./hello-sh.sh a "b c" ' ${d} '
seq 10 | ./hello-sh.sh a "b c" ' ${d} '
@

<<prog>>=
thisprog=${1}; shift # the initial script
echo "running ${0} on \"${SH}\", with args:"
for arg; do echo "    arg: [${arg}]"; done
echo
printf -- 'Hello world!\n\n'

# avoid reading from the terminal/tty
[ -t 0 ] && exec </dev/null

perl -lne'print(qq{STDIN: ${_}})'
@
