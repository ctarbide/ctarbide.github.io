#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
set -- "$@" --tmp-- .o --tmp-- .out
SH=${SH:-sh}; export SH
exec nofake-exec.sh --error -Rprog "$@" -- "${SH}" -eu -c '
    nasm -f elf -o "${0}.o" "${0}"
    ld -m elf_i386 -o "${0}.out" "${0}.o"
    exec "${0}.out" "$@"
'
exit 1

This is a live literate program.

<<tested with versions>>=
- NASM version 2.16.01 compiled on Apr 21 2023
@

<<references>>=
- https://www.secureideas.com/blog/2021/05/linux-x86-assembly-how-to-build-a-hello-world-program-in-nasm.html

@

<<prog>>=
global _start

section .data
    msg: db "hello world!", 0xa
    len: equ $ - msg

section .text
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80
