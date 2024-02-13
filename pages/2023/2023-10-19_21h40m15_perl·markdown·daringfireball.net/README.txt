
<<md url>>=
https://daringfireball.net/projects/markdown/
@

<<md zip>>=
https://daringfireball.net/projects/downloads/Markdown_1.0.1.zip
@

<<references>>=
- [<<md url>>](<<md url>>)

    - [<<md zip>>](<<md zip>>)

This uses a slightly modified version of [markdown v1.0.1](<<md zip>>)
@

<<body>>=
<h1><<TITLE>></h1>
<p> This page was automatically generated with these abstract recipes:
<pre><code>
<<htmlified snippets>>
</code></pre>
<h2>References</h2>
<<rendered references>>
<p> See <a href="README.txt">README.txt</a> for more details.
<<Markdown Readme.text.html>>
@

<<YEAR>>=
2023
@

<<STAMP>>=
2023-10-19_21h40m15
@

<<ITEM_ID>>=
perl·markdown·daringfireball.net
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

<<standard data>>=
<<print LAST MODIFIED>>
cat <<PRIMARY SOURCES>>
@

<<aux data>>=
printf '@<<rendered references>>=\n'
nofake -Rreferences README.txt | <<assets - md.pl for pages>>
printf '@\n'
<<md Markdown Readme.text>>
<<htmlify render chunk>>
<<htmlify generate chunk>>
<<htmlify 'aux data' chunk>>
@

<<generate>>=
<<sh preamble>>
<<standard data>>
<<aux data>>
@

<<create index.html from .index.html>>=
cat .index.html > index.html
<<generated: $t1 - $t0>> @>> index.html
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
nofake --error -Rgenerate <<PRIMARY SOURCES>> | sh | CHMOD='chmod 0444' nofake.sh --error -Rindex.html -o.index.html
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

<<md Markdown Readme.text>>=
printf '\n@<<Markdown Readme.text.html>>=\n'
unzip -p Markdown_1.0.1.zip 'Markdown_1.0.1/Markdown Readme.text' |
    perl -lpe's,\@daringfireball.net,\@redacted.net,' | ./md.pl
printf '\n@\n'
@

<<htmlify render chunk>>=
printf '@<<html snippet of '"'"'render'"'"'>>=\n'
nofake-htmlify-chunk.sh render <<PRIMARY SOURCES>>
printf '@\n'
<<htmlified snippets>>=
&lt;&lt;render&gt;&gt;=
<<html snippet of 'render'>>
@@
@

<<htmlify generate chunk>>=
printf '@<<html snippet of '"'"'generate'"'"'>>=\n'
nofake-htmlify-chunk.sh generate <<PRIMARY SOURCES>>
printf '@\n'
<<htmlified snippets>>=
&lt;&lt;generate&gt;&gt;=
<<html snippet of 'generate'>>
@@
@

<<htmlify 'aux data' chunk>>=
printf '@<<html snippet of '"'"'aux data'"'"'>>=\n'
nofake-htmlify-chunk.sh 'aux data' <<PRIMARY SOURCES>>
printf '@\n'
<<htmlified snippets>>=
&lt;&lt;aux data&gt;&gt;=
<<html snippet of 'aux data'>>
@@
@
