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

<<try this>>=
./hello-c.sh a 'b c' ' ${d} '
@

<<hello-c.c>>=
<<c standards>>
<<includes>>
<<int main()>>
@

<<int main()>>=
int
main(int argc, char **argv)
{
    int i = 0;
    for (; i < argc; i++) {
        fprintf(stdout, "[%d:%s]\n", i, argv[i]);
    }
    puts("hello world!");
    return 0;
}
@

<<prog>>=
thisprog=${1}; shift # the initial script
saveargs=`for arg; do printf -- " '%s'" "${arg}"; done`
<<call compiler>>
eval "set -- ${saveargs}"
./hello-c "$@"
@

<<call compiler>>=
eval "set -- ${CC} ${CFLAGS} ${LDFLAGS} -ohello-c"
nofake-exec.sh --error -L -Rhello-c.c -ohello-c.c \
    "${thisprog}" -- "$@"
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
thisprog=hello-c.sh
CC=gcc
LDFLAGS=
set --
<<pedantic CFLAGS options for gcc>>
CFLAGS=`for arg; do printf -- " '%s'" "${arg}"; done`
<<call compiler>>
@

nofake hello-c.sh | sh | sh && ./hello-c a 'b c' ' ${d} '

<<*>>=
nofake --error -Rpedantic hello-c.sh
@

<<c standards>>=
#ifndef _BSD_SOURCE
#define _BSD_SOURCE
#endif
#ifndef _ISOC99_SOURCE
#define _ISOC99_SOURCE
#endif
#ifndef _XOPEN_SOURCE
#define _XOPEN_SOURCE		600
#endif
#ifndef _POSIX_C_SOURCE
#define _POSIX_C_SOURCE		200112L
#endif
@

<<includes>>=
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
@
