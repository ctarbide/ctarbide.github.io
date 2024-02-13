#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
SH=${SH:-sh}; export SH
exec nofake-exec.sh --error -Rmain "$@" -- "${SH}" -eu
exit 1

This is a live literate program.

'main' is just a gathering stage, it adds 'PRIMARY SOURCES' from README.txt to
the processing then goes to 'htmlify all hellos and thisprog'

<<main>>=
thisprog=${1} # the initial script
mainprog=${0}
primsrcs=`nofake --error -R'PRIMARY SOURCES' README.txt`
set -- "${thisprog}" ${primsrcs} --ba-- "$@" ${primsrcs} --ea--
nofake-exec.sh --error -R'htmlify all hellos and thisprog' "$@" -- "${SH}" -eu
@

<<htmlify all hellos and thisprog>>=
thisprog=${1} # the initial script
<<asset - function escape>>
for i in "${thisprog}" hello-*.sh; do
    i=${i#./}
    if [ ! -e "${i}.html" -o "${i}" -nt "${i}.html" ]; then
        ( <<htmlify "${i}">> ) | <<md-autoheader-autolink.pl>> |
            <<assets - md.pl for pages>> >"${i}.html"
    fi
done
@

<<htmlify "${i}">>=
nofake --error -R'html preamble' "$@"
test -f index.html && printf -- '### [index.html](index.html)\n\n'
test -f README.txt && printf -- '### [README.txt](README.txt)\n\n'
test -f README.html && printf -- '### [README.html](README.html)\n\n'
printf '**** Code for [`%s`](%s):\n\n' "${i}" "${i}"
printf '<pre style="margin-left: 3ch;"><code>'
escape "${i}"
printf '</code></pre>\n'
@

<<html preamble>>=
<!DOCTYPE html>
<html lang="en">
<<style>>
@
