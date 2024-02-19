#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- cpp
exit 1

This is a live literate program.

<<references>>=
- https://jorenar.com/blog/less-known-c.html#x-macros

- https://stackoverflow.com/questions/6635851/real-world-use-of-x-macros

- https://github.com/ctarbide/mcpp

@

<<hello world example>>=
#define MAP_TO_ITEMS_DETAILED(A,B,C,F) \
    A(F(hello)) \
    B(F(world)) \
    C(F(!))

#define PLUS(x) x+
#define SPACE(x) x
#define IDENTITY(x) x

#define MAP_TO_ITEMS_PLUS(F) MAP_TO_ITEMS_DETAILED(PLUS,PLUS,IDENTITY,F)

#define MAP_TO_ITEMS_SPACE(F) MAP_TO_ITEMS_DETAILED(SPACE,SPACE,IDENTITY,F)

#define STRLEN(a) strlen(#a)

MAP_TO_ITEMS_SPACE(IDENTITY);
MAP_TO_ITEMS_PLUS(STRLEN);
@

<<prog>>=
<<hello world example>>
@
