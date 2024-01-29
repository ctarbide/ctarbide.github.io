
<<body in markdown>>=
<h1><<TITLE>></h1>

This is a continuation of the examples shown in <<link to scsh·examples>>.

To run them yourself, put the code in a `file.scm` then run
`scsh -s file.scm`.

See the <a href="#references">references</a> below for more information.

**************** Examples

**** hello

[code](hello.sh):

<<htmlified hello prog>>

output:

<<htmlified hello output>>

**** run

[code](run.sh):

<<htmlified run prog>>

output:

<<htmlified run output>>

**** fork-waitpid-exec

[code](fork-waitpid-exec.sh):

<<htmlified fork-waitpid-exec prog>>

output

<<htmlified fork-waitpid-exec output>>

**************** References

<p id="references">These are the the combined references from the scripts above.</p>

<<references>>

More details in the link below.
@

<<references>>=
<<references from hello.sh>>
<<references from run.sh>>
<<references from fork-waitpid-exec.sh>>
@

<<YEAR>>=
2024
@

<<STAMP>>=
2024-01-29_10h43m49
@

<<ITEM_ID>>=
scsh·ipc·fork·exec·waitpid·run
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

<<gen: link to scsh·examples>>=
printf '@<<link to scsh·examples>>=\n'
<<TOP>>/bin/find-raw.sh 2024-01 scsh examples |
    perl -lne'print qq{[scsh examples](<<PAGES>>/${_})}'
printf '@\n'
@

<<gen: references>>=
cat *.sh | nofake-export-chunks.sh \
  'references from hello.sh' \
  'references from fork-waitpid-exec.sh' \
  'references from run.sh'
@

<<function escape>>=
escape(){ perl -lpe's,<,&lt;,g; s,^\@,&#x40;,' -- "$@"; }
@

<<gen: htmlified hello prog>>=
printf '@<<htmlified hello prog>>=\n<pre><code>'
nofake --error -Rprog hello.sh | escape
printf '</code></pre>\n@\n'
@

<<gen: htmlified run prog>>=
printf '@<<htmlified run prog>>=\n<pre><code>'
nofake --error -Rprog run.sh | escape
printf '</code></pre>\n@\n'
@

<<gen: htmlified fork-waitpid-exec prog>>=
printf '@<<htmlified fork-waitpid-exec prog>>=\n<pre><code>'
nofake --error -Rprog fork-waitpid-exec.sh | escape
printf '</code></pre>\n@\n'
@

<<gen: htmlified hello output>>=
printf '@<<htmlified hello output>>=\n<pre><code>'
./hello.sh | escape
printf '</code></pre>\n@\n'
@

<<gen: htmlified run output>>=
printf '@<<htmlified run output>>=\n<pre><code>'
./run.sh | escape
printf '</code></pre>\n@\n'
@

<<gen: htmlified fork-waitpid-exec output>>=
printf '@<<htmlified fork-waitpid-exec output>>=\n<pre><code>'
./fork-waitpid-exec.sh | escape
printf '</code></pre>\n@\n'
@

<<generate>>=
<<sh preamble>>
<<function escape>>
<<print LAST MODIFIED>>
cat <<PRIMARY SOURCES>>
<<gen: base url>>
<<gen: references>>
<<gen: link to scsh·examples>>
<<gen: htmlified hello prog>>
<<gen: htmlified run prog>>
<<gen: htmlified fork-waitpid-exec prog>>
<<gen: htmlified hello output>>
<<gen: htmlified run output>>
<<gen: htmlified fork-waitpid-exec output>>
@

<<function autoheader_and_autolink>>=
autoheader_and_autolink(){
    perl -lpe'
        s,^\*{64} (.*)$,<h1>${1}</h1>,;
        s,^\*{16} (.*)$,<h2>${1}</h2>,;
        s,^\*{4} (.*)$,<h3>${1}</h3>,;
        s,
            (^|[^\w<])
            ( https? :// [\w\-.]+ / (?: [\w\-./?=&%\#]* [\w/] )? )
            ([^\w>]|$)
        ,${1}<${2}>${3},xg;
    '
}
@

<<assets - md.pl for pages -- cat>>=
cat
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

