#!/bin/sh
set -eu
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}
configname="${thisdir}/website.cfg"
configure(){
    if [ x"${1#*.}" = x"${1}" ] || ! git config -f "${configname}" "$@"; then
        name="website.${1}"; shift
        git config -f "${configname}" "${name}" "$@"
    fi
}
configure configname "${configname}"
configure kbdir "${thisdir%/*}/pages"
configure kbdir-from-top-level "pages"
configure base-url "https://ctarbide.github.io/"
