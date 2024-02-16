#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
SH=${SH:-sh}; export SH
CC=${CC:-gcc}; export CC
CFLAGS=${CFLAGS:-"-Wall -O2 -ansi"}; export CFLAGS
LDFLAGS=${LDFLAGS:-}; export LDFLAGS
exec nofake-exec.sh --error -Rmain "$@" -- "${SH}" -eu
exit 1

This is a live literate program.

<<doit.c>>=
<<c standards>>
<<includes>>
<<definitions>>
<<unions>>
<<protos>>
<<impl>>
<<int main()>>
@

<<main>>=
thisprog=${1}; shift # the initial script
<<call compiler>>
rm -f output.nw
printf -- '@<<output>>=\n' > output.nw
./doit | tee -a output.nw
printf -- '@\n' >> output.nw
make # update index.html
@

<<call compiler>>=
eval "set -- ${CC} ${CFLAGS} ${LDFLAGS} -odoit"
nofake-exec.sh --error -L -Rdoit.c -odoit.c \
  "${thisprog}" plumbing.nw main.nw -- "$@"
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
thisprog=doit.sh
CC=gcc
LDFLAGS=
set --
<<pedantic CFLAGS options for gcc>>
CFLAGS=`for arg; do printf -- " '%s'" "${arg}"; done`
<<call compiler>>
@

nofake doit.sh | sh | sh && ./doit

<<*>>=
nofake --error -Rpedantic doit.sh plumbing.nw main.nw
@
