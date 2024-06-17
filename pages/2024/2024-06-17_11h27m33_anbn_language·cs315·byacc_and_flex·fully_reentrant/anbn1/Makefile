CC = gcc
CFLAGS = -ansi -pedantic
OPTFLAGS = -O2
WFLAGS = -Wall -Wextra -Werror -Wstrict-prototypes -Wmissing-prototypes \
	-Wshadow -Wconversion -fmax-errors=1

anbn: Makefile y.tab.c lex.yy.c
	$(CC) $(CFLAGS) $(OPTFLAGS) $(WFLAGS) -o anbn y.tab.c

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
