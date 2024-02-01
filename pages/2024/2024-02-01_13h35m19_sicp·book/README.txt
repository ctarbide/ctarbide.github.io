
<<celeb>>=
http://ds26gte.github.io/tex2page/celeb.html
@

<<references>>=
- <<<celeb>>>

@

<<body in markdown>>=
<h1><<TITLE>></h1>

From [Some TeX2page examples] [CELEB]:

[CELEB]: <<celeb>>

<table>
<tr><td>[1]&nbsp;&nbsp;&nbsp;&nbsp;<td>
Harold Abelson and Gerald&#xa0;Jay Sussman with Julie Sussman.
<i><a href="http://mitpress.mit.edu/sicp/full-text/book/book.html">Structure and Interpretation of Computer Programs(“SICP”)</a></i>.
MIT Press, 2nd edition, 1996.
</table>

We learn that `curl-head-info.sh https://mitpress.mit.edu/sicp/full-text/book/book.html` gives:

    HTTP/1.1 404 Not Found
    Content-Type: text/html; charset=UTF-8
    Server: cloudflare
    Date: Thu, 01 Feb 2024 13:50:53 GMT

Plain `http` fails too, not surprised, not a bit, [made a copy in 2020](<<<assets - base url>>sicp-book/book.html>).

<h2>References</h2>

<<references>>

More details in the link below.
@

<<YEAR>>=
2024
@

<<STAMP>>=
2024-02-01_13h35m19
@

<<ITEM_ID>>=
sicp·book
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
    last-modified.sh README.txt | perl -MPOSIX=strftime \
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

<<generate>>=
<<sh preamble>>
<<print LAST MODIFIED>>
cat <<PRIMARY SOURCES>>
<<gen: base url>>
@

<<function autoheader_and_autolink>>=
autoheader_and_autolink(){ cat; }
@

<<update (or not) .index.html from primary sources>>=
nofake --error -Rgenerate <<PRIMARY SOURCES>> | sh | gzip > .cache
<<function autoheader_and_autolink>>
(
    gzip -dc .cache
    printf '@<<body>>=\n'
    gzip -dc .cache | nofake --error -R'body in markdown' |
        autoheader_and_autolink | <<assets - md.pl for pages>>
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

