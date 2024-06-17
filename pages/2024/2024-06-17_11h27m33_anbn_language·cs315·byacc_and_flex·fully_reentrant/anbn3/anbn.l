%{
#define YY_DECL int yylex__reentrant(yyscan_t yyscanner)
%}
%option yylineno
%option noinput nounput
%option reentrant
%option extra-type="anbn_program *"
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
