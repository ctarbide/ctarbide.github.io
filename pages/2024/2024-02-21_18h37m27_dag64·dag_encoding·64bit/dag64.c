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
#line 19 "dag64.nw"
#define HI12_MASK 0xfff00000
#define LO52_MASK 0x000fffffffffffff
#define BIT_52_SET ((uint64_t)1 << (52 - 1))
#line 25 "dag64.nw"
#define SPECIALS_ARRAY_MASK 0x3
#line 193 "dag64.nw"
#define E_BITS 11
#define E_MAX ((1<<(E_BITS-1))-1)
#define E_MIN (1 - E_MAX)
#define E_RANGE_PER_SIGNAL (E_MAX - E_MIN + 1)
#define E_BIAS_START 0x002
#define E_BIAS_END (E_RANGE_PER_SIGNAL * 2 - 1 + E_BIAS_START)
#line 244 "dag64.nw"
#define EAS_CUSTOM_1 0x001
#define EAS_CUSTOM_2 0xffe
#define EAS_SPECIAL 0xfff
#define SPECIAL_DNAN 0, 0
#define SPECIAL_P_INF 0, 1
#define SPECIAL_N_INF 0, 2
#line 101 "common.nw"
#define DBLEXP(x) (1023+(x))
#define DBLEXP_NORMALIZE(x) ((x)-1023)
#line 59 "common.nw"
union double_value {
#line 16 "common.nw"
    struct {
        uint32_t lo32;
        unsigned int hi20:20;
        unsigned int bexp:11;
        unsigned int sign:1;
    } parts;
#line 32 "common.nw"
    struct {
        uint32_t lo;
        uint32_t hi;
    } u32;
#line 51 "common.nw"
    struct {
        uint32_t lo32;
        unsigned int hi20:20;
        unsigned int eas:12;
    } normal;
#line 63 "common.nw"
    unsigned char o[8]; /* octets */
    double d;
    int64_t i;
    uint64_t u;
};
#line 38 "dag64.nw"
void
show_long_bits(char *label, double x);
#line 142 "dag64.nw"
double
as_double(double);
#line 182 "dag64.nw"
union double_value
create_normal(unsigned sign, int exp, uint32_t hi20, uint32_t lo32);
#line 221 "dag64.nw"
union double_value
create_special(uint32_t hi20, uint32_t lo32);
union double_value
create_custom_1(uint32_t hi20, uint32_t lo32);
union double_value
create_custom_2(uint32_t hi20, uint32_t lo32);
#line 335 "dag64.nw"
void
dag64(void);
#line 106 "common.nw"
double
create_double(unsigned sign, unsigned bexp, uint32_t hi20, uint32_t lo32);
#line 126 "common.nw"
double
machine_epsilon(double x);
#line 75 "common.nw"
union double_value dnan = {{ 0, 0x80000, DBLEXP(1024), 1 }};
#line 29 "dag64.nw"
union double_value specials[SPECIALS_ARRAY_MASK + 1] = {
#line 75 "common.nw"
    {{ 0, 0x80000, DBLEXP(1024), 1 }},
#line 83 "common.nw"
    {{ 0, 0, DBLEXP(1024), 0 }},
#line 91 "common.nw"
    {{ 0, 0, DBLEXP(1024), 1 }},
#line 75 "common.nw"
    {{ 0, 0x80000, DBLEXP(1024), 1 }}
};
#line 89 "dag64.nw"
void
show_long_bits(char *label, double x)
{
    char buf[100];
    union double_value dv;
    uint32_t type;

    dv.d = x;
    type = (dv.u32.hi + 0x00200000u) >> 20u;

    if (type < 4u) {
        /* type in [0,3], right? */
        enum { CUSTOM_2, SPECIAL, INTEGER, CUSTOM_1 } type_e = type;
        switch (type_e) {
        case INTEGER: {
                int64_t i = (int64_t)((dv.u ^ BIT_52_SET) - BIT_52_SET);
                if (i < 0) {
                    snprintf(buf, sizeof buf, "(int) %"PRId64" or %"PRId64, dv.i, i);
                } else {
                    snprintf(buf, sizeof buf, "(int) %"PRId64, i);
                }
            }
            break;
        case CUSTOM_1: {
                uint64_t payload = dv.u & LO52_MASK;
                snprintf(buf, sizeof buf, "(custom 1) 0x%013"PRIx64, payload);
            }
            break;
        case CUSTOM_2: {
                uint64_t payload = dv.u & LO52_MASK;
                snprintf(buf, sizeof buf, "(custom 2) 0x%013"PRIx64, payload);
            }
            break;
        case SPECIAL: {
                unsigned idx = dv.u32.lo & SPECIALS_ARRAY_MASK;
                snprintf(buf, sizeof buf, "(special %d: %f)", idx, specials[idx].d);
            }
            break;
        }
    } else {
        snprintf(buf, sizeof buf, "(normal)");
    }

    printf("%16.16s -> 0x%.016"PRIx64" -> %e %s\n",
        label, dv.u, as_double(dv.d), buf);
}
#line 147 "dag64.nw"
double
as_double(double x)
{
    union double_value dv, out;
    uint32_t hi12;

    out.d = dv.d = x;
    hi12 = dv.u32.hi & HI12_MASK;

    if (hi12 == 0) {
        int64_t i = (int64_t)((dv.u ^ BIT_52_SET) - BIT_52_SET);
        out.d = (double)i;
        /* out.d = (double)dv.u; */
    } else if (hi12 == ((uint32_t)EAS_CUSTOM_1 << 20)) {
        out = dnan;
        out.u32.lo = 1;
    } else if (hi12 == ((uint32_t)EAS_SPECIAL << 20)) {
        unsigned idx = dv.u32.lo & SPECIALS_ARRAY_MASK;
        out = specials[idx];
    } else if (hi12 == ((uint32_t)EAS_CUSTOM_2 << 20)) {
        out = dnan;
        out.u32.lo = 2;
    } else {
        /* a normal, restore IEEE754 biased exponent */
        unsigned int eas = dv.normal.eas;
        unsigned int bexp = eas - E_BIAS_START + 1 -
            ((unsigned)E_RANGE_PER_SIGNAL * dv.parts.sign);
        out.parts.bexp = bexp & 0x7ff;
    }

    return out.d;
}
#line 202 "dag64.nw"
union double_value
create_normal(unsigned sign, int exp, uint32_t hi20, uint32_t lo32)
{
    union double_value x;
    if (exp >= E_MIN && exp <= E_MAX) {
        x.normal.eas = (
                (unsigned)(exp - E_MIN + E_BIAS_START) +
                ((unsigned)E_RANGE_PER_SIGNAL * sign)
            ) & 0xfff;
        x.normal.hi20 = hi20 & 0xfffff;
        x.normal.lo32 = lo32;
    } else {
        x = dnan;
    }
    return x;
}
#line 253 "dag64.nw"
union double_value
create_special(uint32_t hi20, uint32_t lo32)
{
    union double_value x;
    x.normal.eas = EAS_SPECIAL;
    x.normal.hi20 = hi20 & 0xfffff;
    x.normal.lo32 = lo32;
    return x;
}
union double_value
create_custom_1(uint32_t hi20, uint32_t lo32)
{
    union double_value x;
    x.normal.eas = EAS_CUSTOM_1;
    x.normal.hi20 = hi20 & 0xfffff;
    x.normal.lo32 = lo32;
    return x;
}
union double_value
create_custom_2(uint32_t hi20, uint32_t lo32)
{
    union double_value x;
    x.normal.eas = EAS_CUSTOM_2;
    x.normal.hi20 = hi20 & 0xfffff;
    x.normal.lo32 = lo32;
    return x;
}
#line 340 "dag64.nw"
void
dag64(void)
{
    show_long_bits("zero", create_double(0, 0, 0, 0));
    show_long_bits("1", create_double(0, 0, 0, 1));
#line 148 "common.nw"
    show_long_bits("2^51 - 1", create_double(0, 0, 0x7ffff, 0xffffffff));
#line 144 "common.nw"
    show_long_bits("2^52 - 1", create_double(0, 0, 0xfffff, 0xffffffff));

    show_long_bits("custom 1", create_custom_1(0x11111, 0x11111111).d);

    show_long_bits("(+) first normal", create_normal(0, E_MIN, 0, 0).d);
#line 144 "common.nw"
    show_long_bits("(+) last normal",  create_normal(0, E_MAX, 0xfffff, 0xffffffff).d);
    show_long_bits("(-) first normal", create_normal(1, E_MIN, 0, 0).d);
#line 144 "common.nw"
    show_long_bits("(-) last normal",  create_normal(1, E_MAX, 0xfffff, 0xffffffff).d);

    show_long_bits("custom 2", create_custom_2(0x22222, 0x22222222).d);

    show_long_bits("dnan", create_special(SPECIAL_DNAN).d);
    show_long_bits("+inf", create_special(SPECIAL_P_INF).d);
    show_long_bits("-inf", create_special(SPECIAL_N_INF).d);
}
#line 113 "common.nw"
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
#line 131 "common.nw"
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
#line 10 "dag64.nw"
int
main(int argc, char **argv)
{
    dag64();
    return 0;
}
