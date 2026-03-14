#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- qjs --script --std
exit 1

This is a live literate program.

<<tested with versions>>=
- QuickJS version 2024-01-13
@

<<references>>=
- https://bellard.org/quickjs/

- https://bellard.org/quickjs/binary_releases/quickjs-cosmo-2024-01-13.zip

@

<<prog>>=
print("hello world!");
