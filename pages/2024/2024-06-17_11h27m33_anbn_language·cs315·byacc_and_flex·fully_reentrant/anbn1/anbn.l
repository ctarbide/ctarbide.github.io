%option yylineno
%option noinput nounput
%option reentrant
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
