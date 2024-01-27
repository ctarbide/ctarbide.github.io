#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}

kbdir=`"${thisdir}/show-config.sh" kbdir`
kbdir_ftl=`"${thisdir}/show-config.sh" kbdir-from-top-level`
test -d "${kbdir}" || die 1 "Error, directory not found: ${kbdir}."

cd "${kbdir}"

find_docs(){
    fy=2018
    cy=`date +%Y`
    set -- # clear $@
    while [ "${cy}" -ge "${fy}" ]; do
        if [ -d "${cy}" ]; then
            set -- "${cy}" "$@"
        fi
        cy=$((cy-1))
    done
    find "$@" -mindepth 2 -maxdepth 2 -a \( -name 'Screenshot_*.png' -o -name 'Screenshot_*.jpg' -o -name README.txt \) -a -type f
}

find_docs | perl -le'
  while(<STDIN>){
    print($1,q{_},$2) if m{^(2.../20\d\d-[01]\d-\d\d_\d\dh\d\dm\d\d)_(.*?)/};
  }
  print for @ARGV;
' "$@" | LC_ALL=C sort | uniq | gzip > index.gz
