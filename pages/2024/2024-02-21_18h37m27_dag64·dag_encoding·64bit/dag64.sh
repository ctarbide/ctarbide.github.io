#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
SH=${SH:-sh}; export SH
CC=${CC:-gcc}; export CC
CFLAGS=${CFLAGS:-"-Wall -O2 -ansi"}; export CFLAGS
LDFLAGS=${LDFLAGS:-}; export LDFLAGS
exec nofake-exec.sh --error -Rprog "$@" -- "${SH}" -eu
exit 1

This is a live literate program.

<<$0>>=
dag64
@

<<sources>>=
<<$0>>.sh <<$0>>.nw config.nw plumbing.nw common.nw
@

<<try this>>=
./hello-c.sh a 'b c' ' ${d} '
@

<<prog>>=
progid='<<$0>>'
thisprog=${1}; shift # the initial script
thisprefix=${thisprog%.sh};
if [ "x${thisprefix##*/}" != "x${progid}" ]; then
    echo 'Error, fix @<<$0>>.' 1>&2
    exit 1
fi
saveargs=`for arg; do printf -- " '%s'" "${arg}"; done`
<<call compiler>>
eval "set -- ${saveargs}"
[ -t 0 ] && exec 0>&-
rm -f bits_out.nw
printf -- "@<<${progid} output>>=\\n" > "${progid}_out.nw"
"${thisprefix}" "$@" | tee -a dag64_out.nw
printf -- '@\n' >> dag64_out.nw
make # update index.html
@

<<call compiler>>=
eval "set -- <<sources>> -- ${CC} ${CFLAGS} ${LDFLAGS} -o'<<$0>>'"
nofake-exec.sh --error -L -R'$0.c' -o'<<$0>>.c' "$@"
@

<<pedantic CFLAGS options for gcc>>=
set -- "$@" -O2 -ansi -pedantic
set -- "$@" -Wall -Wextra -Wstrict-prototypes -Wmissing-prototypes
set -- "$@" -Wshadow -Wconversion -Wdeclaration-after-statement
set -- "$@" -Wno-unused-parameter
set -- "$@" -Werror -fmax-errors=5
@

<<pedantic>>=
#!/bin/sh
set -eu
thisprog='<<$0>>.sh'
CC=gcc
LDFLAGS=
set --
<<pedantic CFLAGS options for gcc>>
CFLAGS=`for arg; do printf -- " '%s'" "${arg}"; done`
<<call compiler>>
@

<<*>>=
nofake --error -Rpedantic <<sources>> | sh &&
    ./'<<$0>>'
@
