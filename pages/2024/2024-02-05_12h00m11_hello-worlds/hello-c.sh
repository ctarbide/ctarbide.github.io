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
hello-c
@

<<sources>>=
<<$0>>.sh
@

<<try this>>=
./<<$0>>.sh a 'b c' ' ${d} '
@

<<$0.c>>=
<<c standards>>
<<includes>>
<<int main()>>
@

<<int main()>>=
int
main(int argc, char **argv)
{
    int i = 0;
    while (fgetc(stdin) != EOF) {
        i++;
    }
    if (i) {
        printf("got %d bytes from standard input\n", i);
    }
    for (i=0; i < argc; i++) {
        fprintf(stdout, "[%d:%s]\n", i, argv[i]);
    }
    puts("hello world!");
    return 0;
}
@

<<prog>>=
progid='<<$0>>'
thisprog=${1}; shift # progid with called path
thisprefix=${thisprog%.sh};
if [ "x${thisprefix##*/}" != "x${progid}" ]; then
    echo 'Error, fix @<<$0>>.' 1>&2
    exit 1
fi
saveargs=`for arg; do printf -- " '%s'" "${arg}"; done`
<<call compiler>>
eval "set -- ${saveargs}"
[ -t 0 ] && exec 0>&-
"${thisprefix}" "$@"
@

<<call compiler>>=
eval "set -- <<sources>> -- ${CC} ${CFLAGS} ${LDFLAGS} -o'${progid}'"
nofake-exec.sh --error -L -R'$0.c' -o"${progid}.c" "$@"
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
progid='<<$0>>'
thisprog="${progid}.sh"
CC=gcc
LDFLAGS=
set --
<<pedantic CFLAGS options for gcc>>
CFLAGS=`for arg; do printf -- " '%s'" "${arg}"; done`
<<call compiler>>
@

<<*>>=
nofake --error -Rpedantic <<sources>> | sh && seq 10 | ./'<<$0>>' a 'b c' ' ${d} '
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
