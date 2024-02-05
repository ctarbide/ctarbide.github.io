#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- icon
exit 1

This is a live literate program.

<<tested with versions>>=
- Icon Version 9.5.22e, July 23, 2022
@

<<prog>>=
procedure main(args)
    write("hello world!")
end
