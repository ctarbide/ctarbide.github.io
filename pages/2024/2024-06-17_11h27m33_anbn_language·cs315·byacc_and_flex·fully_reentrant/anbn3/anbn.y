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

int main()
{
    anbn_program p[1] = {{123, "foo"}};
    int status;
    yyscan_t scanner;

    /* yylex_init(&scanner) -> yylex_init_extra(p, &scanner)
     * due to "%option extra-type" in anbn.l
     */
    yylex_init_extra(p, &scanner);
    status = yyparse(scanner);
    yylex_destroy(scanner);

    return status;
}

void yyerror(yyscan_t scanner, char *s)
{
    anbn_program *p;
    /* "lineno - 1" since the rule ends with '\n'
     */
    p = yyget_extra(scanner);
    fprintf(stderr, "%s in line %d (scanner id %d)\n", s,
        yyget_lineno(scanner) - 1, p->id);
}

int yylex(YYSTYPE *yylval, yyscan_t yyscanner)
{
    (void)yylval;
    return yylex__reentrant(yyscanner);
}
