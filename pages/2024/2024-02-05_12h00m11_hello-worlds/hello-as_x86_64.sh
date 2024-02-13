#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "$@" --ea--
set -- "$@" --tmp-- .o --tmp-- .out
SH=${SH:-sh}; export SH
exec nofake-exec.sh --error -Rprog "$@" -- "${SH}" -eu -c '
    as -march=generic64 -64 "${0}" -o "${0}.o"
    ld -m elf_x86_64 "${0}.o" -o "${0}.out"
    exec "${0}.out" "$@"
'
exit 1

This is a live literate program.

<<tested with versions>>=
- GNU assembler (GNU Binutils) 2.39
@

<<references>>=
- https://cs.lmu.edu/~ray/notes/gasexamples/

- hello-nasm_x86_64.sh

- hello-as_x86.sh

@

<<prog>>=
.global  _start

.data
msg:
    .ascii "hello world!\n"
    len = . - msg

.text
_start:
    mov $1, %rax      # write(
    mov $1, %rdi      #   STDOUT_FILENO,
    mov $msg, %rsi    #   "hello world!\n",
    mov $len, %rdx    #   sizeof("Hello, world!\n")
    syscall           # );

    mov $60, %rax     # exit(
    xor %rdi, %rdi    #   EXIT_SUCCESS
    syscall           # );
