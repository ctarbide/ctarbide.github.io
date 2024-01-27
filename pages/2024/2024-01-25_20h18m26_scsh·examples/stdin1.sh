#!/bin/sh
set -eu; thisprog=$0 aa=
for i; do
    case "${i}" in
        --) aa=${aa:+${aa} }"'--dd--'" ;;
        *) aa=${aa:+${aa} }"'--aa' '${i}'" ;;
    esac
done
eval "set -- ${aa}"
exec nofake-exec.sh --error -Rprog "${thisprog}" "$@" -- scsh -s
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
