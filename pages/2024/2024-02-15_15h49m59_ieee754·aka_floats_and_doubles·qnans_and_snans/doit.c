#line 3 "plumbing.nw"
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
#line 18 "plumbing.nw"
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <math.h>
/* #include <fcntl.h> */
/* #include <unistd.h> */
#line 37 "main.nw"
#define DBLEXP(x) (1023+(x))
#define DBLEXP_NORMALIZE(x) ((x)-1023)
#line 25 "main.nw"
union double_value {
#line 16 "main.nw"
    struct {
        uint32_t lo32;
        unsigned int hi20:20;
        unsigned int bexp:11;
        unsigned int sign:1;
    } parts;
#line 27 "main.nw"
    unsigned char o[8]; /* octets */
    double d;
    int64_t i;
    uint64_t u;
};
#line 42 "main.nw"
double create_double(unsigned sign, unsigned bexp, uint32_t hi20, uint32_t lo32);
#line 60 "main.nw"
void
show_double(char *label, double x);
#line 85 "main.nw"
void show_created_double(char *label, unsigned sign, unsigned bexp,
    uint32_t hi20, uint32_t lo32);
#line 98 "main.nw"
double machine_epsilon(double x);
#line 48 "main.nw"
double create_double(unsigned sign, unsigned bexp, uint32_t hi20, uint32_t lo32)
{
    union double_value x;
    x.parts.sign = sign & 0x1;
    x.parts.bexp = bexp & 0x7ff;
    x.parts.hi20 = hi20 & 0xfffff;
    x.parts.lo32 = lo32;
    return x.d;
}
#line 65 "main.nw"
void
show_double(char *label, double x)
{
    char buf[100];
    union double_value dv;
    dv.d = x;
    if (fabs(x) < 1 && fabs(x) > 0) {
        snprintf(buf, sizeof buf, "%.7f", dv.d);
    } else {
        snprintf(buf, sizeof buf, "%.2f", dv.d);
    }
    printf("%15.15s -> %10.10s      (sign: %d, bexp: %3x %05x %08x, "
        "bytes: %02x%02x%02x%02x%02x%02x%02x%02x)\n", label, buf,
        dv.parts.sign, dv.parts.bexp, dv.parts.hi20, dv.parts.lo32,
        dv.o[0], dv.o[1], dv.o[2], dv.o[3],
        dv.o[4], dv.o[5], dv.o[6], dv.o[7]);
}
#line 90 "main.nw"
void show_created_double(char *label, unsigned sign, unsigned bexp,
    uint32_t hi20, uint32_t lo32)
{
    show_double(label, create_double(sign, bexp, hi20, lo32));
}
#line 102 "main.nw"
double machine_epsilon(double x)
{
    union double_value v;
    v.d = x;
    /* v.parts.lo32++; */
    /* return v.parts.sign ? x - v.d : v.d - x; */
    v.i++;
    return v.i < 0 ? x - v.d : v.d - x;
}
#line 114 "main.nw"
int
main(int argc, char **argv)
{
    double one = 1;
    double m1 = -1;
    double zero = 0.0;
    double inf1 = one / zero;
    double nan1 = sqrt(-1);
    double nan2 = fmod(INFINITY, one);
    double nan3 = fmod(one, zero);

    show_double("-1", m1);
    show_double("1 / 0", inf1);
    show_double("sqrt(-1)", nan1);
    show_double("inf % 1", nan2);
    show_double("1 % 0", nan3);

    show_created_double("0", 0, 0, 0, 0);
    show_created_double("1", 0, DBLEXP(0), 0, 0);
    show_created_double("-1", 1, DBLEXP(0), 0, 0);

    /* 2047 = bias(1024) = 0x7ff = 0b11111111111 = all 11 biased-exponent
     * bits set
     */
    show_created_double("inf", 0, DBLEXP(1024), 0, 0);
    show_created_double("-inf", 1, DBLEXP(1024), 0, 0);

    /* sNaN, signaling NaN (sign is indifferent) */
    show_created_double("first +sNaN", 0, DBLEXP(1024), 0, 1);
    show_created_double("last +sNaN", 0, DBLEXP(1024), 0x7ffff, (uint32_t)~0);

    /* qNaN, quiet NaN (sign is indifferent) */
    show_created_double("first +qNaN", 0, DBLEXP(1024), 0x80000, 0);
    show_created_double("last +qNaN", 0, DBLEXP(1024), 0xfffff, (uint32_t)~0);


    show_created_double("1 * 2^0", 0, DBLEXP(0), 0, 0);
    show_created_double("1 * 2^1", 0, DBLEXP(1), 0, 0);
    show_created_double("1 * 2^2", 0, DBLEXP(2), 0, 0);
    show_created_double("1 * 2^3", 0, DBLEXP(3), 0, 0);
    show_created_double("1 * 2^4", 0, DBLEXP(4), 0, 0);
    show_created_double("1 * 2^5", 0, DBLEXP(5), 0, 0);
    show_created_double("1 * 2^6", 0, DBLEXP(6), 0, 0);
    show_created_double("1 * 2^7", 0, DBLEXP(7), 0, 0);

    show_created_double("1 / 2^1", 0, DBLEXP(-1), 0, 0);
    show_created_double("1 / 2^2", 0, DBLEXP(-2), 0, 0);
    show_created_double("1 / 2^3", 0, DBLEXP(-3), 0, 0);
    show_created_double("1 / 2^4", 0, DBLEXP(-4), 0, 0);
    show_created_double("1 / 2^5", 0, DBLEXP(-5), 0, 0);
    show_created_double("1 / 2^6", 0, DBLEXP(-6), 0, 0);
    show_created_double("1 / 2^7", 0, DBLEXP(-7), 0, 0);

    printf("%15.15s -> %.1f (maximum integer before skipping occurs)\n",
        "2^53", create_double(0, DBLEXP(53), 0, 0));

    printf("%15.15s -> %.1f (smallest number greater than 2^53, skipped)\n",
        "...", create_double(0, DBLEXP(53), 0, 1));

    printf("%15.15s -> %e (formal machine epsilon, lapack)\n",
        "2^-53", create_double(0, DBLEXP(-53), 0, 0));

    printf("%15.15s -> %e (machine epsilon, iso c std, mathematica, matlab)\n",
        "2^-52", create_double(0, DBLEXP(-52), 0, 0));

    printf("%15.15s -> %e (machine_epsilon(1.0))\n",
        "2^-52", machine_epsilon(1.0));

    printf("%15.15s -> %e (machine_epsilon(-1.0))\n",
        "2^-52", machine_epsilon(-1.0));

    printf("%15.15s -> %.2f (machine_epsilon(2^51))\n",
        "0.5", machine_epsilon(create_double(0, DBLEXP(51), 0, 0)));

    printf("%15.15s -> %.2f (machine_epsilon(2^52))\n",
        "1.0", machine_epsilon(create_double(0, DBLEXP(52), 0, 0)));

    printf("%15.15s -> %.2f (machine_epsilon(2^53), greater than unit, will skip)\n",
        "2.0", machine_epsilon(create_double(0, DBLEXP(53), 0, 0)));

    return 0;
}
