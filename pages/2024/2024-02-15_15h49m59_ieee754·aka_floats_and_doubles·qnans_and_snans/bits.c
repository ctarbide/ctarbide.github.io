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
#line 37 "common.nw"
#define DBLEXP(x) (1023+(x))
#define DBLEXP_NORMALIZE(x) ((x)-1023)
#line 25 "common.nw"
union double_value {
#line 16 "common.nw"
    struct {
        uint32_t lo32;
        unsigned int hi20:20;
        unsigned int bexp:11;
        unsigned int sign:1;
    } parts;
#line 27 "common.nw"
    unsigned char o[8]; /* octets */
    double d;
    int64_t i;
    uint64_t u;
};
#line 42 "common.nw"
double
create_double(unsigned sign, unsigned bexp, uint32_t hi20, uint32_t lo32);
#line 62 "common.nw"
double
machine_epsilon(double x);
#line 3 "bits.nw"
void
show_long_bits(char *label, double x);
#line 28 "bits.nw"
void
show_bytes(char *label, double x);
#line 45 "bits.nw"
void
bits(void);
#line 49 "common.nw"
double
create_double(unsigned sign, unsigned bexp, uint32_t hi20, uint32_t lo32)
{
    union double_value x;
    x.parts.sign = sign & 0x1;
    x.parts.bexp = bexp & 0x7ff;
    x.parts.hi20 = hi20 & 0xfffff;
    x.parts.lo32 = lo32;
    return x.d;
}
#line 67 "common.nw"
double
machine_epsilon(double x)
{
    union double_value v;
    v.d = x;
    /* v.parts.lo32++; */
    /* return v.parts.sign ? x - v.d : v.d - x; */
    v.i++;
    return v.i < 0 ? x - v.d : v.d - x;
}
#line 8 "bits.nw"
void
show_long_bits(char *label, double x)
{
    char exp[64];
    union double_value dv;
    dv.d = x;
    if (dv.parts.bexp == 0) {
        snprintf(exp, sizeof exp, "(special)");
    } else {
        snprintf(exp, sizeof exp, "* 2 ^ unbias(%3x)", dv.parts.bexp);
    }
    printf("%16.16s  ->  0x%.016"PRIx64"  "
        "%c1.%05x_%08x  %-18.18s  %e\n",
        label, dv.u, dv.parts.sign ? '-' : '+',
        dv.parts.hi20, dv.parts.lo32, exp, dv.d);
}
#line 33 "bits.nw"
void
show_bytes(char *label, double x)
{
    union double_value dv;
    dv.d = x;
    printf("%15.15s ->   %02x%02x%02x%02x%02x%02x%02x%02x (octets/bytes)\n",
        label, dv.o[0], dv.o[1], dv.o[2], dv.o[3], dv.o[4], dv.o[5], dv.o[6],
        dv.o[7]);
}
#line 54 "bits.nw"
void
bits(void)
{
    show_long_bits("zero", create_double(0, 0, 0, 0));
    show_long_bits("first subnormal", create_double(0, 0, 0, 1));
#line 80 "common.nw"
    show_long_bits("last subnormal", create_double(0, 0, 0xfffff, 0xffffffff));
    show_long_bits("first normal", create_double(0, 1, 0, 0));
    show_long_bits("first normal", create_double(0, 1, 0, 1));
    show_long_bits("2^(-53)", create_double(0, DBLEXP(-53), 0, 0));
    show_long_bits("one", create_double(0, DBLEXP(0), 0, 0));
    show_long_bits("2^(+53)", create_double(0, DBLEXP(+53), 0, 0));
#line 80 "common.nw"
    show_long_bits("last normal", create_double(0, DBLEXP(1023), 0xfffff, 0xffffffff));
    show_long_bits("infinite", create_double(0, DBLEXP(1024), 0, 0));
#line 88 "common.nw"
    show_long_bits("first snan", create_double(0, DBLEXP(1024), 0, 1));
#line 92 "common.nw"
    show_long_bits("last snan", create_double(0, DBLEXP(1024), 0x7ffff, 0xffffffff));
#line 96 "common.nw"
    show_long_bits("first qnan", create_double(0, DBLEXP(1024), 0x80000, 0));
#line 80 "common.nw"
    show_long_bits("last qnan", create_double(0, DBLEXP(1024), 0xfffff, 0xffffffff));
#line 80 "common.nw"
    show_long_bits("(-) last qnan", create_double(1, DBLEXP(1024), 0xfffff, 0xffffffff));
}
#line 21 "./bits.sh"
int
main(int argc, char **argv)
{
    bits();
    return 0;
}
