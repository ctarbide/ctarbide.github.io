#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
SH=${SH:-sh}; export SH
CC=${CC:-gcc}; export CC
CFLAGS=${CFLAGS:-"-Wall -O2 -ansi"}; export CFLAGS
LDFLAGS=${LDFLAGS:-}; export LDFLAGS
exec nofake-exec.sh --error -Rbasics "$@" -- "${SH}" -eu
exit 1

This is a live literate program.

<<basics.c>>=
<<c standards>>
<<includes>>
<<definitions>>
<<unions>>
<<protos>>
<<impl>>
int
main(int argc, char **argv)
{
    basics();
    return 0;
}
@

<<basics>>=
thisprog=${1}; shift # the initial script
<<compile basics>>
rm -f basics_out.nw
printf -- '@<<basics output>>=\n' > basics_out.nw
./basics | tee -a basics_out.nw
printf -- '@\n' >> basics_out.nw
make # update index.html
@

<<compile basics>>=
set -- config.nw plumbing.nw basics.nw
eval "set -- "'"$@"'" -- ${CC} ${CFLAGS} ${LDFLAGS} -obasics"
nofake-exec.sh --error -L -Rbasics.c -obasics.c \
  "${thisprog}" "$@"
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
thisprog=basics.sh
CC=gcc
LDFLAGS=
set --
<<pedantic CFLAGS options for gcc>>
CFLAGS=`for arg; do printf -- " '%s'" "${arg}"; done`
<<compile basics>>
@

nofake basics.sh | sh | sh && ./basics

<<*>>=
nofake --error -Rpedantic basics.sh plumbing.nw basics.nw
@
