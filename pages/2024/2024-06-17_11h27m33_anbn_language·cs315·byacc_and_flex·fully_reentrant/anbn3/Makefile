CC = gcc
CFLAGS = -ansi -pedantic
OPTFLAGS = -O2
WFLAGS = -Wall -Wextra -Werror -Wstrict-prototypes -Wmissing-prototypes \
	-Wshadow -Wconversion -fmax-errors=1

COMPILE = $(CC) $(CFLAGS) $(OPTFLAGS) $(WFLAGS)

anbn: Makefile y.tab.c lex.yy.c anbn.c
	$(COMPILE) -o anbn anbn.c

y.tab.c y.tab.h: anbn.y
	yacc -v -d anbn.y
	perl -lni -e'next if m{^ \s* \# \s* include \s+ }x; print' y.tab.c

lex.yy.c: anbn.l
	flex anbn.l
	perl -lni -e'next if m{^ \s* \# \s* include \s+ }x; print' lex.yy.c

anbn.c: Makefile rtt-aux.nw anbn.nw
	nofake.sh --error -R'$@' -o'$@' rtt-aux.nw anbn.nw

rtt-aux.nw: Makefile rtt-aux.r y.tab.h lex.yy.c y.tab.c
	nofake --error rtt-aux.r | sh | nofake-coalesce.pl >rtt-aux.nw

.PHONY: clean
clean:
	rm -f lex.yy.c y.tab.c rtt-aux.nw anbn.c anbn
	rm -f y.output y.tab.h lex.yy.h
	rm -f *.stamp

.PHONY: test
test:
	./test.sh
