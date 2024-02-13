
<<body in markdown>>=
<h1><<TITLE>></h1>

**************** from simple to complex

- [hello cat](hello-cat.sh.html)

- [hello perl](hello-perl.sh.html)

- [hello sh](hello-sh.sh.html)

- [hello nasm x86_64](hello-nasm_x86_64.sh.html)

- [hello awk](hello-awk.sh.html)

- [hello scheme, scheme48](hello-scheme-scheme48.sh.html)

- [hello sh perl](hello-sh-perl.sh.html)

**************** hello pdf?

[Sure](hello-pdf.sh.html), here is the [output](hello-pdf.pdf).

**************** Is there more?

Sure, these are the ones so far:

<<listing of all hellos>>

More to come, as time goes by.

**************** What is going on here?

It all started in <<link to scsh·examples>>.

Here is the [htmlifier of worlds](htmlify-all-hellos.sh.html).

More details in the link below.
@

<<YEAR>>=
2024
@

<<STAMP>>=
2024-02-05_12h00m11
@

<<ITEM_ID>>=
hello-worlds
@

<<PAGE DIR>>=
pages/<<YEAR>>/<<STAMP>>_<<ITEM_ID>>
@

<<URL PREFIX>>=
<<assets - base url>><<PAGE DIR>>
@

<<CANONICAL URL>>=
<<URL PREFIX>>/index.html
@

<<*>>=
<<sh preamble>>
if git-file-is-pristine.sh README.txt; then
    rm -f .draft
else
    date '+%Y-%m-%d_%Hh%Mm%S' > .draft
    git reset --quiet -- index.html
fi
nofake --error -Rrender <<PRIMARY SOURCES>> | sh
@
<<PRIMARY SOURCES>>=
<<TOP>>/assets.nw README.txt
@

<<TOP>>=
../../..
@

<<PAGES>>=
../..
@

<<TITLE>>=
ctarbi.de - hello worlds
@

<<sh preamble>>=
#!/bin/sh
set -eu
@

<<print LAST MODIFIED>>=
if [ -f .draft ]; then
    last-modified.sh README.txt htmlify-all-hellos.sh hello-*.sh | perl -MPOSIX=strftime \
        -lne'print(strftime(qq{@<<LAST MODIFIED@>>=\n%B %e, %Y (DRAFT)\n@\n}, gmtime($_)))'
else
    FORMAT='format:%B %e, %Y at %T UTC' git-last-modified.sh README.txt | perl \
        -lne'print(qq{@<<LAST MODIFIED@>>=\n${_}\n@\n})'
fi
@

<<set $t0>>=
t0=`perl -MTime::HiRes=time -le'print(time)'`
@

<<generated: $t1 - $t0>>=
perl -MTime::HiRes=time -MPOSIX=strftime -le'
    $t1 = time;
    $t0 = $ARGV[0];
    printf(qq{\n<!-- Generated in %.3f seconds on %s. -->\n},
        $t1 - $t0, strftime(q{%B %e, %Y at %T UTC}, gmtime))
' -- "${t0}"
@

<<create index.html from .index.html>>=
cat .index.html > index.html
<<generated: $t1 - $t0>> @>> index.html
chmod 0444 index.html
@

<<update (or not) index.html from .index.html>>=
if [ -f index.html ]; then
    if [ .index.html -nt index.html ]; then
        rm -f index.html
        <<create index.html from .index.html>>
    else
        echo "index.html is up to date."
    fi
else
    <<create index.html from .index.html>>
fi
@

<<gen: base url>>=
printf '@<<base url>>=\n'
<<TOP>>/bin/show-config.sh website.base-url
printf '@\n'
@

<<gen: link to scsh·examples>>=
printf '@<<link to scsh·examples>>=\n'
<<TOP>>/bin/find-raw.sh 2024-01 scsh examples |
    perl -lne'print qq{[scsh examples](<<PAGES>>/${_})}'
printf '@\n'
@

<<${i} -> name>>=
perl -sle'$_=$n; s,_,&#x5f;,g; print $1 if m{^ hello- (.*) \.sh\.html $}xi' -- -n="${i}"
@

<<gen: listing of all hellos>>=
printf '@<<listing of all hellos>>=\n'
for i in hello-*.sh.html; do
    name=`<<${i} -> name>>`
    printf -- '- [%s](%s)\n\n' "${name}" "${i}"
done
printf '\n@\n'
@

<<generate>>=
<<sh preamble>>
<<print LAST MODIFIED>>
cat <<PRIMARY SOURCES>>
<<gen: base url>>
<<gen: link to scsh·examples>>
<<gen: listing of all hellos>>
@

<<md-autoheader-autolink.pl>>=
<<TOP>>/bin/md-autoheader-autolink.pl
@

<<update (or not) .index.html from primary sources>>=
./htmlify-all-hellos.sh
nofake --error -Rgenerate <<PRIMARY SOURCES>> | sh | gzip > .cache
(
    gzip -dc .cache
    printf '@<<body>>=\n'
    gzip -dc .cache | nofake --error -R'body in markdown' |
        <<md-autoheader-autolink.pl>> |
        <<assets - md.pl for pages>>
    printf '@\n'
) | CHMOD='chmod 0444' nofake.sh --error -Rindex.html -o.index.html
@

<<render>>=
<<sh preamble>>
<<set $t0>>
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
<link rel="canonical" href="<<CANONICAL URL>>">
<link rel="icon" href="<<assets - favicon.ico for pages>>" type="image/x-icon">
@

<<footer>>=
<p> This <a href="README.txt">page</a> was last modified on <<LAST MODIFIED>>.
@
