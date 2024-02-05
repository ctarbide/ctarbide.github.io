#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
# set -- "$@" --tmp-- .out
SH=${SH:-sh}; export SH
exec nofake-exec.sh --error -Rprog "$@" -- "${SH}" -eu -c '
    csc -o "${0}.out" "${0}"
    exec "${0}.out" "$@"
'
exit 1

This is a live literate program.

Alternate version, self deleting the executable (not needed if use --tmp--
nofake-exec.sh flag, commented above).

<<tested with versions>>=
- Version 5.3.0 (rev e31bbee5)
@

<<references>>=
- https://wiki.call-cc.org/man/5/Using%20the%20interpreter

- https://wiki.call-cc.org/man/5/Module%20(chicken%20process-context)

- https://wiki.call-cc.org/man/5/Module%20(chicken%20file)

@

<<prog>>=
(display "hello world!\n")
(import (chicken process-context)
        (chicken file))
(delete-file (car (argv)))
