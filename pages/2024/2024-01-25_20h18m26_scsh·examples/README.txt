
<<body in markdown>>=
<h1><<TITLE>></h1>
<h2>Snippets</h2>

<<snippet listing>>

<h2>Live Literate Program</h2>

All scripts follow the *live literate program* technique, some examples:

[hello1](hello1.sh):

<<htmlified hello1.sh>>

[hello2](hello2.sh):

<<htmlified hello2.sh>>

`nofake-exec.sh` is provided by [coolscripts](https://github.com/ctarbide/coolscripts).

<h2>References</h2>
<<references>>

More details in the link below.
@

<<YEAR>>=
2024
@

<<STAMP>>=
2024-01-25_20h18m26
@

<<ITEM_ID>>=
scsh·examples
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
ctarbi.de - <<ITEM_ID>>
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

<<standard data>>=
<<print LAST MODIFIED>>
cat <<PRIMARY SOURCES>>
@

<<aux data>>=
<<asset - function escape>>
printf '@<<references>>=\n'
nofake --error -Rreferences README.txt *.sh | LC_ALL=C sort -u
printf '@\n'
printf '@<<htmlified hello1.sh>>=\n<pre><code>'
escape hello1.sh
printf '</code></pre>\n@\n'
printf '@<<htmlified hello2.sh>>=\n<pre><code>'
escape hello2.sh
printf '</code></pre>\n@\n'
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

<<update (or not) .index.html from primary sources>>=
nofake --error -R'sh preamble' -R'standard data' -R'aux data' -R'list snippets' \
    <<PRIMARY SOURCES>> | sh | gzip > .cache
(
    gzip -dc .cache
    printf '@<<body>>=\n'
    gzip -dc .cache | nofake --error -R'body in markdown' | <<assets - md.pl for pages>>
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

<<md prefix>>=
2023/2023-10-19_21h40m15_perl·markdown·daringfireball.net/
@

<<snippets 0>>=
hello1.sh hello2.sh args1.sh args2.sh args3.sh
<<snippets 1>>=
for-each1.sh fac1.sh fac2.sh fac3.sh
<<snippets 2>>=
list-path.sh list-executables.sh stdin1.sh
<<snippets>>=
<<snippets 0>> <<snippets 1>> <<snippets 2>>
@

<<list snippets>>=
for i in <<snippets>>; do
    j=${i%.sh}
    printf '@<<%s snippet>>=\n<pre><code>' "${j}"
    nofake-htmlify-chunk.sh prog "${i}"
    printf '</code></pre>\n'
    printf '@<<snippet listing>>=\n'
    printf '[%s](%s):\n\n' "${j}" "${i}"
    printf '@<<%s snippet>>\n\n' "${j}"
done
printf '@\n'
@
