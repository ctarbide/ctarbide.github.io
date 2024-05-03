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
#line 22 "plumbing.nw"
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
#define DEBUG_POINTER_NAME(PTR) debug_get_pointer_name(PTR)
#line 141 "lconcat.nw"
#ifndef SIZE_MAX
#define SIZE_MAX ((size_t)-1)
#endif
#line 56 "plumbing.nw"
/* placeholder */
#line 22 "reallocarray.nw"
/*
 * This is sqrt(SIZE_MAX+1), as s1*s2 <= SIZE_MAX
 * if both s1 < MUL_NO_OVERFLOW and s2 < MUL_NO_OVERFLOW
 */
#define MUL_NO_OVERFLOW ((size_t)1 << (sizeof(size_t) * 4))
#line 32 "wip.nw"
#line 36 "plumbing.nw"
/* placeholder */
#line 33 "wip.nw"
#line 40 "plumbing.nw"
/* placeholder */
#line 34 "wip.nw"
#line 60 "plumbing.nw"
/* placeholder */
#line 35 "wip.nw"
#line 44 "plumbing.nw"
/* placeholder */
#line 36 "wip.nw"
int
debug_set_pointer_name(void *ptr, char *name);
char *
debug_get_pointer_name(void *ptr);
#line 3 "hello.nw"
void hello(void);
#line 28 "lconcat.nw"
char *
concat(const char *s1, ...);
#line 90 "lconcat.nw"
size_t
lconcat(char *dst, size_t dstsize, const char *s1, ...);
#line 30 "reallocarray.nw"
void *
xreallocarray(void *optr, size_t nmemb, size_t size);
#line 32 "strlcat.nw"
size_t
xstrlcat(char *dst, const char *src, size_t dsize);
#line 31 "strlcpy.nw"
size_t
xstrlcpy(char *dst, const char *src, size_t dsize);
#line 37 "wip.nw"
int so_far = 0;
static struct {
    struct {
        int size, tally;
        char **names;
        void **pointers;
    } pointers;
    char buf[100];
} g_debug_data = {0};
#line 48 "plumbing.nw"
/* placeholder */
#line 38 "wip.nw"
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
#line 25 "hello.nw"
    fprintf(stderr, "TRACE:%s:%i: step %i: " "hello %s!"
#line 26 "hello.nw"
        "\n", __FILE__, (int)__LINE__, so_far++, "world"
#line 27 "hello.nw"
        );
    if (so_far > 100) {
        fprintf(stderr, "Time is up Cinderella.\n");
        exit(1);
    }
#line 13 "hello.nw"
#line 35 "hello.nw"
    {
        char *str;
#line 31 "hello.nw"
        str = concat("hello", " ", "world", "!", NULL);
#line 38 "hello.nw"
        printf("%d [%s] (%d bytes)\n", __LINE__, str, (int)strlen(str));
        free(str);
        str = NULL;
    }
#line 14 "hello.nw"
#line 45 "hello.nw"
    {
        char *str;
        char buf10[10] = {0};
        char buf20[20] = {0};
#line 31 "hello.nw"
        str = concat("hello", " ", "world", "!", NULL);
#line 50 "hello.nw"
#line 31 "hello.nw"
        printf("needed buffer size: %d bytes\n", (int)(lconcat(NULL, 0, "hello", " ", "world", "!", NULL) + 1));
#line 51 "hello.nw"
        if (xstrlcpy(buf10, str, sizeof(buf10)) >= sizeof(buf10)) {
            if (xstrlcpy(buf20, str, sizeof(buf20)) >= sizeof(buf20)) {
                fprintf(stderr, "%d exhaustion\n", __LINE__);
                exit(1);
            }
            printf("%d [%s] (%d bytes)\n", __LINE__, buf20, (int)strlen(buf20));
        } else {
            printf("%d [%s] (%d bytes)\n", __LINE__, buf10, (int)strlen(buf10));
        }
        free(str);
        str = NULL;
    }
#line 15 "hello.nw"
#line 66 "hello.nw"
    {
        char buf10[10] = {0};
        char buf20[20] = {0};
#line 31 "hello.nw"
        printf("needed buffer size: %d bytes\n", (int)(lconcat(NULL, 0, "hello", " ", "world", "!", NULL) + 1));
#line 70 "hello.nw"
#line 31 "hello.nw"
        if (lconcat(buf10, sizeof(buf10), "hello", " ", "world", "!", NULL) >= sizeof(buf10)) {
#line 71 "hello.nw"
#line 31 "hello.nw"
            if (lconcat(buf20, sizeof(buf20), "hello", " ", "world", "!", NULL) >= sizeof(buf20)) {
#line 72 "hello.nw"
                fprintf(stderr, "%d exhaustion\n", __LINE__);
                exit(1);
            }
            printf("%d [%s] (%d bytes)\n", __LINE__, buf20, (int)strlen(buf20));
        } else {
            printf("%d [%s] (%d bytes)\n", __LINE__, buf10, (int)strlen(buf10));
        }
    }

#line 16 "hello.nw"
#line 82 "hello.nw"
    {
#line 31 "hello.nw"
        char *pieces[] = {"hello", " ", "world", "!"};
#line 84 "hello.nw"
        char buf10[10] = {0};
        char buf20[20] = {0};
        char *buf, *piece;
        int i;
        size_t nbytes_previous, nbytes = 0, bufsz;
        buf = buf10;
        bufsz = sizeof(buf10);
        for (i=0; i<(int)(sizeof(pieces)/sizeof(*pieces)); i++) {
            piece = pieces[i];
            nbytes_previous = nbytes;
            nbytes = xstrlcat(buf, piece, bufsz);
            if (nbytes >= bufsz) {
                char *tmp;
                if (buf == buf20) {
                    /* nowhere to go */
                    fprintf(stderr, "%d exhaustion\n", __LINE__);
                    exit(1);
                }
                /* undo last failed operation */
                buf[nbytes_previous] = 0;
                /* increase buffer */
                tmp = buf;
                buf = buf20;
                bufsz = sizeof(buf20);
                /* retry */
    #if 0
                if (xstrlcpy(buf, tmp, bufsz) >= bufsz) {
                    fprintf(stderr, "%d exhaustion\n", __LINE__);
                    exit(1);
                }
                if (xstrlcat(buf, piece, bufsz) >= bufsz) {
                    fprintf(stderr, "%d exhaustion\n", __LINE__);
                    exit(1);
                }
    #else
                if (lconcat(buf, bufsz, tmp, piece, NULL) >= bufsz) {
                    fprintf(stderr, "%d exhaustion\n", __LINE__);
                    exit(1);
                }
    #endif
            }
        }
        printf("%d [%s] (%d bytes)\n", __LINE__, buf, (int)strlen(buf));
    }
#line 17 "hello.nw"
}
#line 33 "lconcat.nw"
char *
concat(const char *s1, ...)
{
    va_list args;
    const char *s;
    char *p, *result;
    size_t l, m, n;

    if (!s1) return NULL;

    m = n = strlen(s1);
    va_start(args, s1);
    while ((s = va_arg(args, char *))) {
        l = strlen(s);
        if ((m += l) < l)
            break;
    }
    va_end(args);
    if (s || m >= INT_MAX)
        return NULL;

    result = (char *)malloc(m + 1);
    if (!result)
        return NULL;

    memcpy(p = result, s1, n);
    p += n;
    va_start(args, s1);
    while ((s = va_arg(args, char *))) {
        l = strlen(s);
        if ((n += l) < l || n > m)
            break;
        memcpy(p, s, l);
        p += l;
    }
    va_end(args);
    if (s || m != n || p != result + n) {
        free(result);
        return NULL;
    }

    *p = '\0';
    return result;
}
#line 95 "lconcat.nw"
size_t
lconcat(char *dst, size_t dstsize, const char *s1, ...)
{
    va_list args;
    size_t l, m;
    const char *s;
    if (!s1) {
        if (dst && dstsize) *dst = '\0';
        return 0;
    }
    s = s1;
    l = m = strlen(s);
    if (dst && dstsize) {
        char *p = dst;
        if (m < dstsize) {
#line 85 "lconcat.nw"
            memcpy(p, s, l);
            p += l;
#line 111 "lconcat.nw"
        }
        va_start(args, s1);
        while ((s = va_arg(args, char *))) {
            l = strlen(s);
            if ((m += l) < l) {
                m = SIZE_MAX;
                break;
            }
            if (m < dstsize) {
#line 85 "lconcat.nw"
                memcpy(p, s, l);
                p += l;
#line 121 "lconcat.nw"
            }
        }
        va_end(args);
        *p = '\0';
    } else {
        va_start(args, s1);
        while ((s = va_arg(args, char *))) {
            l = strlen(s);
            if ((m += l) < l) {
                m = SIZE_MAX;
                break;
            }
        }
        va_end(args);
    }
    return m;
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
#line 37 "strlcat.nw"
size_t
xstrlcat(char *dst, const char *src, size_t dsize)
{
    const char *odst = dst;
    const char *osrc = src;
    size_t n = dsize;
    size_t dlen, diff;

    /* Find the end of dst and adjust bytes left but don't go past end. */
    while (n-- != 0 && *dst != '\0') {
        dst++;
    }
    dlen = (size_t)(dst - odst);    /* dst only advances, unsigned safe */
    n = dsize - dlen;

    if (n-- == 0) {
        return dlen + strlen(src);
    }
    while (*src != '\0') {
        if (n != 0) {
            *dst++ = *src;
            n--;
        }
        src++;
    }
    *dst = '\0';

    diff = (size_t)(src - osrc);    /* src only advances, unsigned safe */
    return dlen + diff;             /* count does not include NUL */
}
#line 36 "strlcpy.nw"
size_t
xstrlcpy(char *dst, const char *src, size_t dsize)
{
    const char *osrc = src;
    size_t nleft = dsize, diff;

    /* Copy as many bytes as will fit. */
    if (nleft != 0) {
        while (--nleft != 0) {
            if ((*dst++ = *src++) == '\0') {
                break;
            }
        }
    }

    /* Not enough room in dst, add NUL and traverse rest of src. */
    if (nleft == 0) {
        if (dsize != 0) {
            *dst = '\0';            /* NUL-terminate dst */
        }
        while (*src++)
            ;
    }

    diff = (size_t)(src - osrc);    /* src only advances, unsigned safe */
    return diff - 1;                /* count does not include NUL */
}
#line 17 "wip.nw"
int
main(int argc, char **argv)
{
#line 64 "plumbing.nw"
    /* placeholder */
#line 21 "wip.nw"
    (void)so_far;
    (void)g_debug_data;
#line 52 "plumbing.nw"
    /* placeholder */
#line 22 "wip.nw"
#line 21 "hello.nw"
    hello();
#line 23 "wip.nw"
    return 0;
}
