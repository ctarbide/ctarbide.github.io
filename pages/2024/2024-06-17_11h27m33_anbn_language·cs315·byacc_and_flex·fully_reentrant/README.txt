
<<references>>=
- <http://www.cs.bilkent.edu.tr/~guvenir/courses/CS315/lex-yacc/index.html>

   - _Lex & Yacc_ ([local copy](lex-yacc.pdf))
   
   - by H. Altay G{\"u}venir
   
- <https://westes.github.io/flex/manual/index.html>

- <https://invisible-island.net/byacc/manpage/yacc.html>
@

<<body in markdown>>=
<h1><<TITLE>></h1>
<h2>References</h2>
<<references>>

**************** Examples

All examples below implements the same grammar for the language
L={a<sup>n</sup>b<sup>n</sup>|n &gt;= 0}.

**** Standard implementation

Standard, non-reentrant implementation:

<<listing of anbn0>>

**** Reentrant scanner

Reentrant scanner (lexical scanner) using
[`flex`](https://github.com/westes/flex):

<<listing of anbn1>>

**** Reentrant scanner and parser

Reentrant scanner and (pure) parser using `flex` and
[`byacc`](https://invisible-island.net/byacc/):

<<listing of anbn2>>

**** Reentrant scanner and parser augumented with `noweb`

[`icon-rtt`](https://github.com/ctarbide/icon-rtt) do a minimum analysis of
the c language sources and translates it to a `noweb` output that removes
most of the rigidity of c source code:

<<listing of anbn3>>

**************** Notes

- All code above is provided [here](https://github.com/ctarbide/ctarbide.github.io).

- Tested with:

   - flex 2.6.4

   - byacc 2.0 20240109


More details in the link below.
@

<<YEAR>>=
2024
@

<<STAMP>>=
2024-06-17_11h27m33
@

<<ITEM_ID>>=
anbn_language·cs315·byacc_and_flex·fully_reentrant
@

<<ITEM_URI>>=
anbn_language%C2%B7cs315%C2%B7byacc_and_flex%C2%B7fully_reentrant
@

<<PAGE DIR>>=
pages/<<YEAR>>/<<STAMP>>_<<ITEM_ID>>
@

<<PAGE URI>>=
pages/<<YEAR>>/<<STAMP>>_<<ITEM_URI>>
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
ctarbi.de - anbn language · reentrant byacc and flex
@

<<sh preamble>>=
#!/bin/sh
set -eu
@

<<print LAST MODIFIED>>=
if [ -f .draft ]; then
    last-modified.sh <<PRIMARY SOURCES>> | perl -MPOSIX=strftime \
        -lne'print(strftime(qq{@<<LAST MODIFIED@>>=\n%B %e, %Y (DRAFT)\n@\n}, gmtime($_)))'
else
    FORMAT='format:%s %B %e, %Y at %T UTC' git-last-modified.sh <<PRIMARY SOURCES>> |
        LC_ALL=C sort -nr | head -n1 | perl \
        -lne's,^\d+ ,,; print(qq{@<<LAST MODIFIED@>>=\n${_}\n@\n})'
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

<<generate>>=
<<sh preamble>>
<<print LAST MODIFIED>>
cat <<PRIMARY SOURCES>>
<<gen: base url>>
<<gen: listing of anbn0>>
<<gen: listing of anbn1>>
<<gen: listing of anbn2>>
<<gen: listing of anbn3>>
@

<<link to ${i}>>=
printf -- '- [`%s`](%s)\n\n' "${i}" "${i}"
@

<<gen: listing of anbn0>>=
printf '@<<listing of anbn0>>=\n'
for i in anbn0/*; do
    <<link to ${i}>>
done
printf '\n@\n'
@

<<gen: listing of anbn1>>=
printf '@<<listing of anbn1>>=\n'
for i in anbn1/*; do
    <<link to ${i}>>
done
printf '\n@\n'
@

<<gen: listing of anbn2>>=
printf '@<<listing of anbn2>>=\n'
for i in anbn2/*; do
    <<link to ${i}>>
done
printf '\n@\n'
@

<<gen: listing of anbn3>>=
printf '@<<listing of anbn3>>=\n'
for i in anbn3/*; do
    <<link to ${i}>>
done
printf '\n@\n'
@

<<update (or not) .index.html from primary sources>>=
nofake --error -Rgenerate <<PRIMARY SOURCES>> | sh | gzip > .cache
(
    gzip -dc .cache
    printf '@<<body>>=\n'
    gzip -dc .cache | nofake --error -R'body in markdown' |
        "<<TOP>>/bin/md-autoheader-autolink.pl" |
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

