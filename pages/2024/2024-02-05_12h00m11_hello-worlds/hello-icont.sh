#!/bin/sh
# https://ctarbide.github.io/pages/2024/TBD_hello-worlds
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -ohello-icont.icn --aa-- -x -- \
    icont -s -N
exit 1

This is a live literate program.

<<tested with versions>>=
- Icon Version 9.5.22e, July 23, 2022
@

<<prog>>=
procedure main(args)
    write("hello world!")
end
