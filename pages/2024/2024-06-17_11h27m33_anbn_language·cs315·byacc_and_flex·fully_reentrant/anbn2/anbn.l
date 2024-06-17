%{
#include "anbn.h"
#include "y.tab.h"
YY_DECL;
%}
%option yylineno
%option noinput nounput
%option reentrant
%option extra-type="void*"
%option header-file="lex.yy.h"
%%
a     return A;
b     return B;
.     return yytext[0];
\n    return '\n';
%%
int yywrap(yyscan_t yyscanner)
{
    (void)yyscanner;
    return 1;
}
