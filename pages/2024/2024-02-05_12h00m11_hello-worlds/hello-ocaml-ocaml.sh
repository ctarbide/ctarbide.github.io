#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --tmp-- .cmi --tmp-- .cmo --tmp-- .byte --suffix .ml
OCAML=${OCAML:-ocaml}; export OCAML
exec nofake-exec.sh --error -Rprog "$@" -- ${OCAML}
exit 1

This is a live literate program.

<<prog>>=
print_endline "hello world!"
@
