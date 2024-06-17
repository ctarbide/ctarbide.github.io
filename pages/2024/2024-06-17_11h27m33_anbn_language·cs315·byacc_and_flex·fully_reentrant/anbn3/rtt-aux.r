/*
<<preamble>>=
#!/bin/sh
set -eu
rtt_gdb(){ gdb --quiet --args rtt "$@"; }
rtt__pure_c__stdout(){
    set -- -D__RTT__=1 -D__RTT_PURE_C__=1 "$@"
    set -- -D__RTT_OUTPUT='"/dev/stdout"' "$@"
    rtt -x "$@"
}
<<rtt>>=
<<preamble>>
rtt__pure_c__stdout rtt-aux.r
<<*>>=
nofake-exec.sh --error -Rrtt rtt-aux.r -- sh -eu
@
 */

#ifndef __RTT__
#error "Not using rtt?"
#endif

#define __STDC__ 1
#define __STDC_VERSION__ 199901L

#ifndef _BSD_SOURCE
#define _BSD_SOURCE
#endif
#ifndef _ISOC99_SOURCE
#define _ISOC99_SOURCE
#endif
#ifndef _XOPEN_SOURCE
#define _XOPEN_SOURCE           600
#endif
#ifndef _POSIX_C_SOURCE
#define _POSIX_C_SOURCE         200112L
#endif

typedef IGNORE __builtin_va_list;
typedef IGNORE va_list;
typedef IGNORE _Bool;

#define __PT__va_start(_1, _2) passthru(va_start(_1, _2))
#define __PT__va_arg(_1, _2) passthru(va_arg(_1, passthru(_2)))
#define __PT__va_end(_1) passthru(va_end(_1))

#define __attribute__(x)

#define restrict
#define inline

#include <stddef.h>
#include <stdarg.h>
#include <inttypes.h>

typedef IGNORE YYSTYPE;

#output __RTT_OUTPUT

#passthru "definitions" #define __PT__(x) x

typedef struct anbn_program {
    int id;
    char *name;
} anbn_program;

#include "y.tab.h"
#include "lex.yy.c"
#include "y.tab.c"
