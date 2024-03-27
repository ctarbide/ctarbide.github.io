#line 28 "wip.nw"
#line 3 "wip.nw"
/* Copyright (c) 2024 by C. Tarbide. You may do as you please with
 * this code as long as you do not remove this copyright notice or
 * hold me liable for its use.
 *
 * generated from:
#line 13 "wip.nw"
- wip.nw: TODO: brief description
#line 9 "wip.nw"
 */
#line 29 "wip.nw"
#line 7 "plumbing.nw"
#ifndef _BSD_SOURCE
#define _BSD_SOURCE
#endif

#ifndef _ISOC99_SOURCE
#define _ISOC99_SOURCE
#endif

#ifndef _XOPEN_SOURCE
#define _XOPEN_SOURCE 600
#endif

#ifndef _POSIX_C_SOURCE
#define _POSIX_C_SOURCE 200112L
#endif
#line 30 "wip.nw"
#line 25 "plumbing.nw"
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#include <limits.h>
#include <stdarg.h>
/* #include <fcntl.h> */
/* #include <unistd.h> */
#line 31 "wip.nw"
#line 59 "plumbing.nw"
/* placeholder */
#define DEBUG_POINTER_NAME(PTR) debug_get_pointer_name(PTR)
#line 22 "reallocarray.nw"
/*
 * This is sqrt(SIZE_MAX+1), as s1*s2 <= SIZE_MAX
 * if both s1 < MUL_NO_OVERFLOW and s2 < MUL_NO_OVERFLOW
 */
#define MUL_NO_OVERFLOW ((size_t)1 << (sizeof(size_t) * 4))
#line 32 "wip.nw"
#line 39 "plumbing.nw"
/* placeholder */
#line 33 "wip.nw"
#line 43 "plumbing.nw"
/* placeholder */
#line 34 "wip.nw"
#line 63 "plumbing.nw"
/* placeholder */
#line 35 "wip.nw"
#line 47 "plumbing.nw"
/* placeholder */
#line 36 "wip.nw"
#line 3 "hello.nw"
void hello(void);
int
debug_set_pointer_name(void *ptr, char *name);
char *
debug_get_pointer_name(void *ptr);
void
exhaustion(void);
#line 30 "reallocarray.nw"
void *
xreallocarray(void *optr, size_t nmemb, size_t size);
#line 37 "wip.nw"
#line 51 "plumbing.nw"
/* placeholder */
static int so_far = 0;
static struct {
    struct {
        int size, tally;
        char **names;
        void **pointers;
    } pointers;
    char buf[100];
} g_debug_data = {0};
#line 38 "wip.nw"
#line 17 "wip.nw"
int
main(int argc, char **argv)
{
#line 67 "plumbing.nw"
    /* placeholder */
#line 21 "wip.nw"
#line 55 "plumbing.nw"
    /* placeholder */
    (void)so_far;
#line 22 "wip.nw"
#line 17 "hello.nw"
    hello();
#line 23 "wip.nw"
    return 0;
}
#line 7 "hello.nw"
void
hello(void)
{
    fprintf(stderr, "TRACE:%s:%i: step %i: " "WIP"
        "\n", __FILE__, (int)__LINE__ - 1, so_far++
        );
    if (so_far > 100) {
        fprintf(stderr, "Time is up Cinderella.\n");
        exit(1);
    }
#line 11 "hello.nw"
    fprintf(stderr, "TRACE:%s:%i: step %i: " "here"
        "\n", __FILE__, (int)__LINE__ - 1, so_far++
        );
    if (so_far > 100) {
        fprintf(stderr, "Time is up Cinderella.\n");
        exit(1);
    }
#line 12 "hello.nw"
#line 21 "hello.nw"
    fprintf(stderr, "TRACE:%s:%i: step %i: " "hello %s!"
#line 22 "hello.nw"
        "\n", __FILE__, (int)__LINE__, so_far++, "world"
#line 23 "hello.nw"
        );
    if (so_far > 100) {
        fprintf(stderr, "Time is up Cinderella.\n");
        exit(1);
    }
#line 13 "hello.nw"
}
int
debug_set_pointer_name(void *ptr, char *name)
{
    int i;
    for (i = 0; i < g_debug_data.pointers.tally; ++i) {
        if (strcmp(g_debug_data.pointers.names[i], name) == 0) {
            g_debug_data.pointers.pointers[i] = ptr;
            return i;
        }
    }
    if (g_debug_data.pointers.size == 0) {
        g_debug_data.pointers.size = 64;
        g_debug_data.pointers.tally = 0;
        g_debug_data.pointers.names = calloc(g_debug_data.pointers.size, sizeof(char*));
        g_debug_data.pointers.pointers = calloc(g_debug_data.pointers.size, sizeof(void*));
    } else if (g_debug_data.pointers.tally == g_debug_data.pointers.size) {
        g_debug_data.pointers.size *= 2;
        g_debug_data.pointers.names = xreallocarray(g_debug_data.pointers.names, g_debug_data.pointers.size, sizeof(char*));
        g_debug_data.pointers.pointers = xreallocarray(g_debug_data.pointers.pointers, g_debug_data.pointers.size, sizeof(void*));
    }
    g_debug_data.pointers.names[g_debug_data.pointers.tally] = strdup(name);
    g_debug_data.pointers.pointers[g_debug_data.pointers.tally] = ptr;
    return g_debug_data.pointers.tally++;
}
char *
debug_get_pointer_name(void *ptr)
{
    int i;
    for (i = 0; i < g_debug_data.pointers.tally; ++i) {
        if (g_debug_data.pointers.pointers[i] == ptr) {
            return g_debug_data.pointers.names[i];
        }
    }
    snprintf(g_debug_data.buf, sizeof(g_debug_data.buf), "(unknown %p)", ptr);
    return g_debug_data.buf;
}
void
exhaustion(void)
{
    fprintf(stderr, "Exhaustion.\n");
    exit(1);
}
#line 35 "reallocarray.nw"
void *
xreallocarray(void *optr, size_t nmemb, size_t size)
{
    if ((nmemb >= MUL_NO_OVERFLOW || size >= MUL_NO_OVERFLOW) &&
        nmemb > 0 && SIZE_MAX / nmemb < size) {
        fprintf(stderr, "Error, cannot re-allocate array, size too large.");
        exit(1);
        /* errno = ENOMEM; */
        /* return NULL; */
    }
    return realloc(optr, size * nmemb);
}
