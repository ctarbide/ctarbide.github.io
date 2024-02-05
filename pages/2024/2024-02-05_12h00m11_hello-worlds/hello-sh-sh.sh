#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --tmp-- .nw
SH=${SH:-sh}; export SH
exec nofake-exec.sh --error -Rprog0 "$@" -- "${SH}" -eu
exit 1

This is a live literate program.

"prog0" is information gathering and preprocessing stage

<<prog0>>=
thisprog=${1}; shift

# avoid reading from the terminal/tty
[ -t 0 ] && exec </dev/null

(
    printf -- '@<<%s>>=\n' 'hello message'
    date +'Hello world! Today is %A, %d %B %Y %T.'
    printf -- '@\n\n'
) >"${0}.nw"

exec nofake-exec.sh --error -Rprog "${thisprog}" "${0}.nw" \
    --ba-- "$@" --ea-- -- "${SH}" -eu
@

<<try this>>=
seq 10 | ./hello-sh-sh.sh a "b c" ' ${d} '
@

"prog" is the final program

<<prog>>=
echo "running ${0} on \"${SH}\", with args:"
for arg; do echo "    arg: [${arg}]"; done
echo
printf -- '%s\n\n' '<<hello message>>'
perl -lne'print(qq{STDIN: ${_}})'
@
