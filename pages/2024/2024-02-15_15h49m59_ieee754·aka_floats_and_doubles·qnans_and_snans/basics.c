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
#line 3 "basics.nw"
void
show_double(char *label, double x);
#line 36 "basics.nw"
void
show_long_bits(char *label, double x);
#line 54 "basics.nw"
void
show_bytes(char *label, double x);
#line 71 "basics.nw"
void
show_created_double(char *label, unsigned sign, unsigned bexp,
    uint32_t hi20, uint32_t lo32);
#line 85 "basics.nw"
void
basics(void);
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
#line 8 "basics.nw"
void
show_double(char *label, double x)
{
    char buf[100];
    union double_value dv;
    dv.d = x;
    if (x == 0) {
        snprintf(buf, sizeof buf, "(special) %.1f");
    } else if (dv.parts.hi20 && dv.parts.lo32) {
        snprintf(buf, sizeof buf, "%.11e", dv.d);
    } else if (fabs(x) < 1 && fabs(x) > 0) {
        snprintf(buf, sizeof buf, "%.7f", dv.d);
    } else {
        snprintf(buf, sizeof buf, "%.2f", dv.d);
    }
    if (x) {
        printf("%12.12s -> %20.20s (%c1.%05x_%08x * 2 ^ unbias(%3x))\n",
            label, buf, dv.parts.sign ? '-' : '+',
            dv.parts.hi20, dv.parts.lo32, dv.parts.bexp);
    } else {
        printf("%12.12s -> %20.20s (%c1.%05x_%08x * 2 ^ %x)\n",
            label, buf, dv.parts.sign ? '-' : '+',
            dv.parts.hi20, dv.parts.lo32, dv.parts.bexp);
    }
}
#line 41 "basics.nw"
void
show_long_bits(char *label, double x)
{
    union double_value dv;
    dv.d = x;
    printf("%12.12s ->   0x%.016" PRIx64 " (%c1.%05x_%08x * 2 ^ unbias(%3x))\n",
        label, dv.u, dv.parts.sign ? '-' : '+',
        dv.parts.hi20, dv.parts.lo32, dv.parts.bexp);
}
#line 59 "basics.nw"
void
show_bytes(char *label, double x)
{
    union double_value dv;
    dv.d = x;
    printf("%15.15s ->   %02x%02x%02x%02x%02x%02x%02x%02x (octets/bytes)\n",
        label, dv.o[0], dv.o[1], dv.o[2], dv.o[3], dv.o[4], dv.o[5], dv.o[6],
        dv.o[7]);
}
#line 77 "basics.nw"
void show_created_double(char *label, unsigned sign, unsigned bexp,
    uint32_t hi20, uint32_t lo32)
{
    show_double(label, create_double(sign, bexp, hi20, lo32));
}
#line 94 "basics.nw"
void
basics(void)
{
    double one = 1;
    double m1 = -1;
    double zero = 0.0;
    double inf1 = one / zero;
    double nan1 = sqrt(-1);
    double nan2 = fmod(INFINITY, one);
    double nan3 = fmod(one, zero);
    double planck_ev = 4.135667696e-15;
    double p0 = create_double(0, 0, 0, 0);
    double m0 = create_double(1, 0, 0, 0);

    /* zero is a special case, the biased exponent of 0 behaves as 0 */
    show_double("0", zero);
    show_double("0", p0);
    show_double("-0", m0);

    show_double("Planck eV", planck_ev);
    /* round(log(4e-15) / log(2)) = -48 */
    show_created_double("Planck eV", 0, DBLEXP(-48), 0x2a019, 0xa830a613);
    show_long_bits("Planck eV", planck_ev);
    show_bytes("Planck eV", planck_ev);

    show_double("1", one);
    show_created_double("1", 0, DBLEXP(0), 0, 0);

    show_double("-1", m1);
    show_created_double("-1", 1, DBLEXP(0), 0, 0);

    /* 2047 = bias(1024) = 0x7ff = 0b11111111111 = all 11 biased-exponent
     * bits set
     */
    show_created_double("-inf", 1, DBLEXP(1024), 0, 0);
    show_created_double("inf", 0, DBLEXP(1024), 0, 0);

    show_double("1 / 0", inf1);

    show_double("sqrt(-1)", nan1);
    show_double("inf % 1", nan2);
    show_double("1 % 0", nan3);

    /* sNaN, signaling NaN (sign is indifferent) */
#line 88 "common.nw"
    show_created_double("first +sNaN", 0, DBLEXP(1024), 0, 1);
#line 92 "common.nw"
    show_created_double("last +sNaN", 0, DBLEXP(1024), 0x7ffff, 0xffffffff);

    /* qNaN, quiet NaN (sign is indifferent) */
#line 96 "common.nw"
    show_created_double("first +qNaN", 0, DBLEXP(1024), 0x80000, 0);
#line 80 "common.nw"
    show_created_double("last +qNaN", 0, DBLEXP(1024), 0xfffff, 0xffffffff);

    show_created_double("1 / 2^7", 0, DBLEXP(-7), 0, 0);
    show_created_double("1 / 2^6", 0, DBLEXP(-6), 0, 0);
    show_created_double("1 / 2^5", 0, DBLEXP(-5), 0, 0);
    show_created_double("1 / 2^4", 0, DBLEXP(-4), 0, 0);
    show_created_double("1 / 2^3", 0, DBLEXP(-3), 0, 0);
    show_created_double("1 / 2^2", 0, DBLEXP(-2), 0, 0);
    show_created_double("1 / 2^1", 0, DBLEXP(-1), 0, 0);

    show_created_double("1 * 2^0", 0, DBLEXP(0), 0, 0);
    show_created_double("1 * 2^1", 0, DBLEXP(1), 0, 0);
    show_created_double("1 * 2^2", 0, DBLEXP(2), 0, 0);
    show_created_double("1 * 2^3", 0, DBLEXP(3), 0, 0);
    show_created_double("1 * 2^4", 0, DBLEXP(4), 0, 0);
    show_created_double("1 * 2^5", 0, DBLEXP(5), 0, 0);
    show_created_double("1 * 2^6", 0, DBLEXP(6), 0, 0);
    show_created_double("1 * 2^7", 0, DBLEXP(7), 0, 0);

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

    printf("%15.15s -> %.1f (maximum integer before skipping occurs)\n",
        "2^53", create_double(0, DBLEXP(53), 0, 0));

    printf("%15.15s -> %.1f (smallest number greater than 2^53)\n",
        "...", create_double(0, DBLEXP(53), 0, 1));
}
#line 21 "./basics.sh"
int
main(int argc, char **argv)
{
    basics();
    return 0;
}
