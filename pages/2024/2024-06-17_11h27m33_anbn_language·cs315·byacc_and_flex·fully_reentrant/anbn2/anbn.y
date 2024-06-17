/*
 * This is the grammar L for the language:
 *
 *    L = { a^n b^n | n >= 0 }
 *
 * See [LY] for more info:
 *
 * - [LY]: http://www.cs.bilkent.edu.tr/~guvenir/courses/CS315/lex-yacc/index.html
 *
 */

%code top {
/* code top */
}

%{
/* code c declarations */
/* define YY_DECL is enough to suppress default forward declaration */
#define YY_DECL
#include "lex.yy.h"
/* undef YY_DECL now so we can define again later */
#undef YY_DECL
%}

%code requires {
/* code requires */
}

%code provides {
/* code provides */
#define YY_DECL int yylex__reentrant(yyscan_t yyscanner)
}

%pure-parser

%lex-param {yyscan_t scanner}
%parse-param {yyscan_t scanner}

%token A B

%%

start
    : anbn '\n' { printf("rule %d match, is in anbn.\n", $$);
                 return 0; }

anbn
    /* : A B */                  /* L = { a^n b^n | n > 0 } */
    : empty                      /* L = { a^n b^n | n >= 0 } */
    | A anbn B
    ;

empty: ;

%%

YY_DECL;

struct anbn_program {
    int id;
    char *name;
};

int main(int argc, char **argv);

int main(int argc, char **argv)
{
    anbn_program p[1] = {{123, "foo"}};
    int status;
    yyscan_t scanner;

    (void)argc;
    (void)argv;

    /* yylex_init(&scanner) -> yylex_init_extra(p, &scanner)
     * due to "%option extra-type" in anbn.l
     */
    yylex_init_extra(p, &scanner);
    status = yyparse(scanner);
    yylex_destroy(scanner);

    return status;
}

void YYERROR_DECL();

void yyerror(yyscan_t scanner, const char *s)
{
    anbn_program *p;
    /* "lineno - 1" since the rule ends with '\n'
     */
    p = yyget_extra(scanner);
    fprintf(stderr, "%s in line %d (scanner id %d)\n", s,
        yyget_lineno(scanner) - 1, p->id);
}

int yylex(YYSTYPE *yylval, yyscan_t yyscanner);
int yylex(YYSTYPE *yylval, yyscan_t yyscanner)
{
   (void)yylval;
   return yylex__reentrant(yyscanner);
}
