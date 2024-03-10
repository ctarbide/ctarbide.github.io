#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --tmp-- .nw
SH=${SH:-sh}; export SH
DOSBOX=${DOSBOX:-dosbox}; export DOSBOX
KBLAYOUT=${KBLAYOUT:-us}; export KBLAYOUT
exec nofake-exec.sh --error -Rprog "$@" -- "${SH}" -eu
exit 1

This is a live literate program.

<<autoexec>>=
mount c "<<CWD>>"
c:
dir hello-~1.sh
echo "hello world!"
@

<<prog>>=
thisprog=${1}; shift
setnw(){ printf -- '@<<%s>>=\n%s\n@\n' "${1}" "${2}" >>"${0}.nw"; }
setnw KBLAYOUT "${KBLAYOUT}" 
setnw CWD "`pwd`"
exec nofake-exec.sh --error -Rconf "${thisprog}" "${0}.nw" -- "${DOSBOX}" -conf
@

<<conf>>=
[dos]
keyboardlayout=<<KBLAYOUT>>
[autoexec]
<<autoexec>>
@
