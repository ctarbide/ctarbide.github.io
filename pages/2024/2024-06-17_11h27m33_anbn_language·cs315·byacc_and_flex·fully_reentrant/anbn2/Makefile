CC = gcc
CFLAGS = -ansi -pedantic
OPTFLAGS = -O2
WFLAGS = -Wall -Wextra -Werror -Wstrict-prototypes -Wmissing-prototypes \
	-Wshadow -Wconversion -fmax-errors=1

COMPILE = $(CC) $(CFLAGS) $(OPTFLAGS) $(WFLAGS)
LINK = $(CC)

anbn: lex.yy.o y.tab.o
	$(LINK) -o anbn $^

lex.yy.o: anbn.h scanner.c lex.yy.c lex.yy.h y.tab.h
	$(COMPILE) -c -o $@ scanner.c

y.tab.o: anbn.h parser.c y.tab.c y.tab.h lex.yy.h
	$(COMPILE) -c -o $@ parser.c

y.tab.c y.tab.h: anbn.y
	yacc -v -d anbn.y

lex.yy.c lex.yy.h: anbn.l
	flex anbn.l

.PHONY: clean
clean:
	rm -f lex.yy.c y.tab.c lex.yy.o y.tab.o anbn
	rm -f y.output y.tab.h lex.yy.h

.PHONY: test
test:
	./test.sh
