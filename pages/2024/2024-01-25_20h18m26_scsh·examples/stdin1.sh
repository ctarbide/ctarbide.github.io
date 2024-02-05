#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
exec nofake-exec.sh --error -Rprog "$@" -- scsh -s
exit 1

This is a live literate program.

<<references>>=
- <https://stackoverflow.com/questions/3173327/getting-a-line-of-user-input-in-scheme>
@

Test this with:

<<*>>=
echo 'the quick brown fox jumps over the lazy dog.' | ./stdin1.sh
@

<<prog>>=
(let ((input (read-line (current-input-port))))
  (for-each (lambda (x) (display x) (newline))
            (string-tokenize input)))
@
