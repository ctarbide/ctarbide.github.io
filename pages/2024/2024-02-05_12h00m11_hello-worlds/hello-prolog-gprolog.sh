#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- gprolog --quiet --consult-file
exit 1

This is a live literate program.

<<tested with versions>>=
- GNU Prolog 1.6.0
@

<<references>>=
- https://stackoverflow.com/questions/3576166/hello-world-in-prolog

- 

@

<<prog>>=
:- initialization(main).
main :-
    write('hello world!'), nl, halt.
