#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}
configname="${thisdir}/website.cfg"
configure(){
    if [ x"${1#*.}" = x"${1}" ] || ! git config -f "${configname}" "$@"; then
        name="website.${1}"; shift
        git config -f "${configname}" "${name}" "$@"
    fi
}

if [ "$#" -lt 1 ]; then
    die 1 "usage: ${thispath##*/} id1 id2 ... idN"
fi

kbdir=`"${thisdir}/show-config.sh" kbdir`
test -d "${kbdir}" || die 1 "Error, directory not found: ${kbdir}."

stamp=`date --utc '+%Y-%m-%d_%Hh%Mm%S'`
year=${stamp%%-*}

item_id=$1
shift
for i in "$@"; do
    item_id="${item_id}·${i}"
done

STAMP=${stamp}
ITEM_ID=${item_id}
DOC_ID=${stamp}_${item_id}
DOCRELDIR=${year}/${DOC_ID}
DOCABSDIR=${kbdir}/${DOCRELDIR}

mkdir -p "${DOCABSDIR}"

"${thisdir}/make-index.sh" "${DOCRELDIR}"

cd "${DOCABSDIR}"

cat <<EOF>README.txt

<<*>>=
nofake --error -Rrender README.txt
@

<<URL_PREFIX>>=
https://ctarbide.github.io/pages/${year}
@

<<TOP>>=
../../..
@

<<STAMP>>=
${STAMP}
@

<<ITEM_ID>>=
${ITEM_ID}
@

<<CANONICAL_URL>>=
<<URL_PREFIX>>/<<STAMP>>_<<ITEM_ID>>/index.html
@

<<print LAST MODIFIED>>=
last-modified.sh README.txt | perl -MPOSIX=strftime \\
    -lne'print(strftime(qq{@<<LAST MODIFIED@>>=\n%B %e, %Y\n@\n}, gmtime(\$_)))'
@

<<render>>=
(
    <<print LAST MODIFIED>>
    cat <<TOP>>/assets.nw README.txt
) | CHMOD='chmod 0444' nofake.sh --error -Rindex.html -oindex.html
@

<<index.html>>=
<!DOCTYPE html>
<html lang="en">
<title>ctarbi.de - <<STAMP>> - <<ITEM_ID>></title>
<<metas and links>>
<<style>>
<<body>>
<<footer>>
@

<<metas and links>>=
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=0.6">
<link rel="canonical" href="<<CANONICAL_URL>>">
<link rel="icon" href="<<assets - favicon.ico for pages>>" type="image/x-icon">
@

<<style>>=
<style>
body {
    width: 90ch;
    max-width: calc(100vw - 4em);
    margin: 2em auto 0 auto;
}
</style>
@

<<footer>>=
<p>
    This <a href="README.txt">page</a> was
    last modified on <<LAST MODIFIED>>.
@

<<body>>=
<h1>Sample Document</h1>
<p>
    This is just a sample paragraph.
@
EOF

echo '(cd '"'${DOCABSDIR}'"' && nofake README.txt)'
