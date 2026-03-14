#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
# https://github.com/ctarbide/coolscripts/blob/master/examples/build-showargs-nl.sh
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --tmp-- .out
SH=${SH:-sh -eu}; export SH
exec nofake-exec.sh --error -Rprog "$@" -- ${SH} -c '
    prog=${1}; shift
    thisprog=${1}; shift
    gcc -Wall -include stdio.h -include string.h -o "${prog}.out" -x c "${prog}"
    exec "${prog}.out" "hello world!" "$@"
' --
exit 1

This is a live literate program.

<<tested with versions>>=
- gcc (GCC) 12.2.0
@

<<prog>>=
int main(int argc, char **argv)
{
    int i = 0;
    for (; i < argc; i++) {
        fprintf(stdout, "[%d:%s]\n", i, argv[i]);
    }
    return 0;
}
