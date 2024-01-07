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

<<references>>=
-
@

<<body>>=
<h1><<TITLE>></h1>
<p> This is just a sample paragraph.
@

<<PRIMARY SOURCES>>=
<<TOP>>/assets.nw README.txt
@

<<URL_PREFIX>>=
https://ctarbide.github.io/pages/${year}
@

<<TOP>>=
../../..
@

<<PAGES>>=
../..
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

<<TITLE>>=
ctarbi.de - <<ITEM_ID>>
@

<<sh preamble>>=
#!/bin/sh
set -eu
@

<<print LAST MODIFIED>>=
if git diff-index --quiet HEAD README.txt; then
    FORMAT='format:%B %e, %Y at %T UTC' git-last-modified.sh README.txt | perl \\
        -lne'print(qq{@<<LAST MODIFIED@>>=\n\${_}\n@\n})'
else
    last-modified.sh README.txt | perl -MPOSIX=strftime \\
        -lne'print(strftime(qq{@<<LAST MODIFIED@>>=\n%B %e, %Y (DRAFT)\n@\n}, gmtime(\$_)))'
fi
@

<<set \$t0>>=
t0=\`perl -MTime::HiRes=time -le'print(time)'\`
@

<<generated: \$t1 - \$t0>>=
perl -MTime::HiRes=time -MPOSIX=strftime -le'
    \$t1 = time;
    \$t0 = \$ARGV[0];
    printf(qq{\n<!-- Generated in %.3f seconds on %s. -->\n},
        \$t1 - \$t0, strftime(q{%B %e, %Y at %T UTC}, gmtime))
' -- "\${t0}"
@

<<standard data>>=
<<print LAST MODIFIED>>
cat <<PRIMARY SOURCES>>
@

<<aux data>>=
: no-op
@

<<generate>>=
<<sh preamble>>
<<standard data>>
<<aux data>>
@

<<create index.html from .index.html>>=
cat .index.html > index.html
<<generated: \$t1 - \$t0>> @>> index.html
chmod 0444 index.html
@

<<update (or not) index.html from .index.html>>=
if [ -f index.html ]; then
    if [ .index.html -nt index.html ]; then
        rm -fv index.html
        <<create index.html from .index.html>>
    else
        echo "index.html is up to date."
    fi
else
    <<create index.html from .index.html>>
fi
@

<<update (or not) .index.html from primary sources>>=
nofake -Rgenerate <<PRIMARY SOURCES>> | sh | CHMOD='chmod 0444' nofake.sh --error -Rindex.html -o.index.html
@

<<render>>=
<<sh preamble>>
<<set \$t0>>
<<update (or not) .index.html from primary sources>>
<<update (or not) index.html from .index.html>>
@

<<index.html>>=
<!DOCTYPE html>
<html lang="en">
<title><<TITLE>></title>
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
<p> This <a href="README.txt">page</a> was last modified on <<LAST MODIFIED>>.
@

<<*>>=
nofake --error -Rrender <<PRIMARY SOURCES>>
@
EOF

echo '(cd '"'${DOCABSDIR}'"' && nofake README.txt)'
