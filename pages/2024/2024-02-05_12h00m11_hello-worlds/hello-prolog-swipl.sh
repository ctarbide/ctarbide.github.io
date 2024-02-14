#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- swipl -q -s
exit 1

This is a live literate program.

<<tested with versions>>=
- SWI-Prolog version 9.1.21
@

<<references>>=
- https://riptutorial.com/prolog/example/15327/hello--world

@

<<prog>>=
:- initialization hello_world, halt.

hello_world :-
    write('hello world!'), nl.
