#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --tmp-- .cmi --tmp-- .cmx --tmp-- .o --tmp-- .native --suffix .ml
SH=${SH:-sh -eu}; export SH
exec nofake-exec.sh --error -Rprog "$@" -- ${SH} -c '
    # ocamlopt -c -dcmm "${1}"
    ocamlopt -o "${1%.ml}.native" "${1}"
    exec "${1%.ml}.native"
' --
exit 1

This is a live literate program.

<<prog>>=
print_endline "hello world!"
@
