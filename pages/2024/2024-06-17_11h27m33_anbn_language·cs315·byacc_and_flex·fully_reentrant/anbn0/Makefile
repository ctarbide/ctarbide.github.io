anbn: Makefile y.tab.c lex.yy.c
	gcc -O2 -Wall -ansi -o anbn y.tab.c

y.tab.c: anbn.y lex.yy.c
	yacc -v -d anbn.y

lex.yy.c: anbn.l
	flex anbn.l

.PHONY: clean
clean:
	rm -f lex.yy.c y.tab.c anbn
	rm -f y.output y.tab.h lex.yy.h

.PHONY: test
test:
	./test.sh
