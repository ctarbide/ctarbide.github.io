#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
SH=${SH:-sh}; export SH
primsrcs=`nofake -R'PRIMARY SOURCES' README.txt`
exec nofake-exec.sh --error -R'prog htmlify-all-hellos.sh and self' \
    ${primsrcs} "$@" -- "${SH}" -eu
exit 1

This is a live literate program.

<<htmlify "${i}">>=
printf -- '<!DOCTYPE html>\n\n'
test -f index.html && printf -- '### [index.html](index.html)\n\n'
test -f README.txt && printf -- '### [README.txt](README.txt)\n\n'
test -f README.html && printf -- '### [README.html](README.html)\n\n'
printf '**** Code for [`%s`](%s):\n\n' "${i}" "${i}"
printf '<pre style="margin-left: 5ch;"><code>'
escape "${i}"
printf '</code></pre>\n'
@

<<prog htmlify-all-hellos.sh and self>>=
<<asset - function escape>>
for i in "${1}" hello-*.sh; do
    i=${i#./}
    if [ ! -e "${i}.html" -o "${i}" -nt "${i}.html" ]; then
        ( <<htmlify "${i}">> ) | <<md-autoheader-autolink.pl>> |
            <<assets - md.pl for pages>> >"${i}.html"
    fi
done
@
