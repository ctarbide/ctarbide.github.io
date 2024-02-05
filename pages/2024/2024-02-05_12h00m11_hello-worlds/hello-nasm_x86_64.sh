#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
set -- "$@" --tmp-- .o --tmp-- .out
SH=${SH:-sh}; export SH
exec nofake-exec.sh --error -Rprog "$@" -- "${SH}" -eu -c '
    nasm -f elf64 -o "${0}.o" "${0}"
    ld -o "${0}.out" "${0}.o"
    exec "${0}.out" "$@"
'
exit 1

This is a live literate program.

<<tested with versions>>=
- NASM version 2.16.01 compiled on Apr 21 2023
@

<<references>>=
- https://jameshfisher.com/2018/03/10/linux-assembly-hello-world/

@

<<prog>>=
global _start

section .text

_start:
    mov rax, 1        ; write(
    mov rdi, 1        ;   STDOUT_FILENO,
    mov rsi, msg      ;   "hello world!\n",
    mov rdx, msglen   ;   sizeof("Hello, world!\n")
    syscall           ; );

    mov rax, 60       ; exit(
    mov rdi, 0        ;   EXIT_SUCCESS
    syscall           ; );

section .rodata
    msg: db "hello world!", 10
    msglen: equ $ - msg
