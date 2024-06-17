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
%}

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

#define YY_NO_INPUT
#define YY_NO_UNPUT

#include "lex.yy.c"

int main()
{
   return yyparse();
}

void yyerror(char *s)
{
   fprintf(stderr, "%s in line %d\n", s, yylineno);
}
