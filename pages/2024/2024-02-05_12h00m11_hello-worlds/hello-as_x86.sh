#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
set -- "$@" --tmp-- .o --tmp-- .out
SH=${SH:-sh}; export SH
exec nofake-exec.sh --error -Rprog "$@" -- "${SH}" -eu -c '
    as -march=i386 -32 "${0}" -o "${0}.o"
    ld -m elf_i386 "${0}.o" -o "${0}.out"
    exec "${0}.out" "$@"
'
exit 1

This is a live literate program.

<<tested with versions>>=
- GNU assembler (GNU Binutils) 2.39
@

<<references>>=
- https://www.secureideas.com/blog/2021/05/linux-x86-assembly-how-to-build-a-hello-world-program-in-gas.html

@

<<prog>>=
.global  _start

.data
msg:
    .ascii "hello world!\n"
    len = . - msg

.text
_start:
    mov    $4, %eax         # syscall: write
    mov    $1, %ebx         # fd=1, stdout
    mov    $msg, %ecx
    mov    $len, %edx
    int    $0x80
    
    mov    $1, %eax         # syscall: exit
    xor    %ebx, %ebx       # status code
    int    $0x80
