#line 97 "hello-c.sh"
#ifndef _BSD_SOURCE
#define _BSD_SOURCE
#endif
#ifndef _ISOC99_SOURCE
#define _ISOC99_SOURCE
#endif
#ifndef _XOPEN_SOURCE
#define _XOPEN_SOURCE		600
#endif
#ifndef _POSIX_C_SOURCE
#define _POSIX_C_SOURCE		200112L
#endif
#line 112 "hello-c.sh"
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#line 33 "hello-c.sh"
int
main(int argc, char **argv)
{
    int i = 0;
    while (fgetc(stdin) != EOF) {
        i++;
    }
    if (i) {
        printf("got %d bytes from standard input\n", i);
    }
    for (i=0; i < argc; i++) {
        fprintf(stdout, "[%d:%s]\n", i, argv[i]);
    }
    puts("hello world!");
    return 0;
}
