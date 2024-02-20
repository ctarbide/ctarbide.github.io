#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
SH=${SH:-sh}; export SH
CC=${CC:-gcc}; export CC
CFLAGS=${CFLAGS:-"-Wall -O2 -ansi"}; export CFLAGS
LDFLAGS=${LDFLAGS:-}; export LDFLAGS
exec nofake-exec.sh --error -Rbits "$@" -- "${SH}" -eu
exit 1

This is a live literate program.

<<bits.c>>=
<<c standards>>
<<includes>>
<<definitions>>
<<unions>>
<<protos>>
<<impl>>
int
main(int argc, char **argv)
{
    bits();
    return 0;
}
@

<<bits>>=
thisprog=${1}; shift # the initial script
<<compile bits>>
rm -f bits_out.nw
printf -- '@<<bits output>>=\n' > bits_out.nw
./bits | tee -a bits_out.nw
printf -- '@\n' >> bits_out.nw
make # update index.html
@

<<compile bits>>=
set -- config.nw plumbing.nw common.nw bits.nw
eval "set -- "'"$@"'" -- ${CC} ${CFLAGS} ${LDFLAGS} -obits"
nofake-exec.sh --error -L -Rbits.c -obits.c \
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
thisprog=./bits.sh
CC=gcc
LDFLAGS=
set --
<<pedantic CFLAGS options for gcc>>
CFLAGS=`for arg; do printf -- " '%s'" "${arg}"; done`
<<compile bits>>
@

nofake bits.sh | sh | sh && ./bits

<<*>>=
nofake --error -Rpedantic bits.sh plumbing.nw common.nw bits.nw
@
