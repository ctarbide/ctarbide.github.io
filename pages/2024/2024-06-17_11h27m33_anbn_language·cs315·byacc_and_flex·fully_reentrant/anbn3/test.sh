#!/bin/sh
set -eu
thispath=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- "${0}"`
thisdir=${thispath%/*}
cd "${thisdir}"

dotgdbinitupdate(){
    CHMOD='chmod 0400' nofake.sh -R.gdbinit -o.gdbinit "${thispath}"
}

if [ x"${gdb:-no}" = xyes ]; then
    make OPTFLAGS='-O0 -g' clean anbn
    dotgdbinitupdate
    gdb --quiet --args ./anbn
    exit 0
else
    if [ -f .gdbinit ]; then
        make clean anbn
        rm -fv .gdbinit
    fi
    make
fi

echo | ./anbn         # expected: rule 0 match, is in anbn.
echo ab | ./anbn      # expected: rule 0 match, is in anbn.
echo aabb | ./anbn    # expected: rule 0 match, is in anbn.
echo aaabbb | ./anbn  # expected: rule 0 match, is in anbn.

exit 0

<<.gdbinit>>=
layout src
b main
r
@
