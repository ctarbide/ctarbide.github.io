#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}
spaces_to_underscore(){
    head=
    tail=${1}
    acc=
    while true; do
        head=${tail%% *}
        tail=${tail#* }
        acc=${acc:+${acc}_}${head}
        if [ x"${tail}" = x"${head}" ]; then
            # didn't advance
            break
        fi
    done
    echo "${acc}"
}

if [ "$#" -lt 1 ]; then
    die 1 "usage: ${thispath##*/} id1 id2 ... idN"
fi

kbdir=`"${thisdir}/show-config.sh" kbdir`
kbdir_ftl=`"${thisdir}/show-config.sh" kbdir-from-top-level`
test -d "${kbdir}" || die 1 "Error, directory not found: ${kbdir}."

stamp=`date --utc '+%Y-%m-%d_%Hh%Mm%S'`
year=${stamp%%-*}

item_id=
for i; do
    j=`spaces_to_underscore "${i}"`
    item_id="${item_id:+${item_id}·}${j}"
done

STAMP=${stamp}
ITEM_ID=${item_id}
ITEM_URI=`perl -MURI::Escape -sle'print uri_escape($n)' -- -n="${ITEM_ID}"`
DOC_ID=${stamp}_${item_id}
DOCRELDIR=${year}/${DOC_ID}
DOCABSDIR=${kbdir}/${DOCRELDIR}

META_DIR=${kbdir}/2024/2024-01-06_15h38m06_meta

mkdir -p "${DOCABSDIR}"

"${thisdir}/make-index.sh" "${DOCRELDIR}"

if [ -r bin/create-config.nw ]; then
    on_top_level=1
else
    on_top_level=0
fi

cd "${DOCABSDIR}"

cp -af "${META_DIR}/Makefile" .

date '+%Y-%m-%d_%Hh%Mm%S' > .hidden

cat - "${META_DIR}/template.nw" <<EOF >README.txt

<<references>>=
- <http://www.literateprogramming.com/>
@

<<body in markdown>>=
<h1><<TITLE>></h1>
<h2>References</h2>
<<references>>

More details in the link below.
@

<<YEAR>>=
${year}
@

<<STAMP>>=
${STAMP}
@

<<ITEM_ID>>=
${ITEM_ID}
@

<<ITEM_URI>>=
${ITEM_URI}
@

<<PAGE DIR>>=
${kbdir_ftl}/<<YEAR>>/<<STAMP>>_<<ITEM_ID>>
@

<<PAGE URI>>=
${kbdir_ftl}/<<YEAR>>/<<STAMP>>_<<ITEM_URI>>
@

<<URL PREFIX>>=
<<assets - base url>><<PAGE URI>>
@

<<CANONICAL URL>>=
<<URL PREFIX>>/index.html
@

<<*>>=
<<sh preamble>>
if git-file-is-pristine.sh <<PRIMARY SOURCES>>; then
    rm -f .draft
else
    date '+%Y-%m-%d_%Hh%Mm%S' > .draft
    git reset --quiet -- index.html
fi
nofake --error -Rrender <<PRIMARY SOURCES>> | sh
@

EOF

if [ "x${on_top_level}" = x1 ]; then
    echo "tmux-new-window.sh '${kbdir_ftl}/${DOCRELDIR}' '${ITEM_ID}'"
else
    echo "tmux-new-window.sh '${DOCABSDIR}' '${ITEM_ID}'"
fi
