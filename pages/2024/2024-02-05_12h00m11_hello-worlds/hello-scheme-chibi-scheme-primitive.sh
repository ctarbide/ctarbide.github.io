#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
SH=${SH:-sh}; export SH
exec nofake-exec.sh --error -Rprog "$@" -- "${SH}" -eu -c '
    exec chibi-scheme -x "chibi primitive" \
        -e "(%load \"${0}\" (current-environment))" -- "$@"
'
exit 1

This is a live literate program.

<<tested with versions>>=
- chibi-scheme 0.10.0 "neon"
@

<<references>>=
- https://github.com/ashinn/chibi-scheme/blob/master/lib/init-7.scm

- https://github.com/ashinn/chibi-scheme/blob/master/lib/meta-7.scm

@

<<test 1>>=
chibi-scheme -x 'chibi primitive' -e '
    (%write-string "hello world!\n" #t (current-output-port))'
<<test 2>>=
chibi-scheme -x 'chibi' -e '
    (%load "hello.scm" (interaction-environment))'
<<test 3>>=
nofake.sh -Rprog -ohello.scm hello-scheme-chibi-scheme-primitive.sh
chibi-scheme -x 'chibi primitive' -e '
    (%load "hello.scm" (current-environment))'
@

<<prog>>=
(%write-string "hello world!\n" #t (current-output-port))
