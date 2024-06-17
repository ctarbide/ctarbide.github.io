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

%{
#define _ISOC99_SOURCE
#define _XOPEN_SOURCE           600
#define _POSIX_C_SOURCE         200112L
#include "y.tab.h"
#include "lex.yy.c"
%}

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

int main(void);
void yyerror(yyscan_t scanner, char *s);

int main()
{
    int status;
    yyscan_t scanner;
    yylex_init(&scanner);
    status = yyparse(scanner);
    yylex_destroy(scanner);
    return status;
}

void yyerror(yyscan_t scanner, char *s)
{
    /* "lineno - 1" since the rule ends with '\n'
     */
    fprintf(stderr, "%s in line %d\n", s, yyget_lineno(scanner) - 1);
}
