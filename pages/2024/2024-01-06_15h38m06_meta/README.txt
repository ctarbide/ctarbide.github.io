
<<references>>=
- [Markdown FTW](<<PAGES>>/<<md prefix>>index.html)

- https://github.com/ctarbide/coolscripts/blob/master/README.txt

    - dependency

- https://github.com/ctarbide/ctweb/blob/master/tools/nofake-README.txt

    - literate programming tool, already included in coolscripts above

- https://stackoverflow.com/questions/5641997/is-it-necessary-to-write-head-body-and-html-tags

    - context: html body tag not required

- https://gist.github.com/pfig/1808188

    - context: imagemagick favicon generator

    - https://www.imagemagick.org/Usage/thumbnails/#favicon

- https://www.atomic-scale-physics.de/lattice/struk.picts/bh.s.png

    - https://www.atomic-scale-physics.de/lattice/faq.html#useofsite

        - "This page is in the public domain."

    - Pictures (and/or text) taken from the Crystal Lattice Structures Web
      page, http://cst-www.nrl.navy.mil/lattice/, provided by the Center for
      Computational Materials Science of the United States Naval Research Laboratory.
@

<<body in markdown>>=
<h1><<TITLE>></h1>
<h2>References</h2>
<<references>>
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

<<YEAR>>=
2024
@

<<STAMP>>=
2024-01-06_15h38m06
@

<<ITEM_ID>>=
meta
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

<<*>>=
<<sh preamble>>
if git-file-is-pristine.sh <<PRIMARY SOURCES>>; then
    rm -f .draft
else
    date '+%Y-%m-%d_%Hh%Mm%S' > .draft
    git reset --quiet -- index.html
fi
nofake --error -Rrender <<PRIMARY SOURCES>> | sh
<<create assets from cache>>
nofake --error -R'create template' <<PRIMARY SOURCES>> | sh
@

<<create assets from cache>>=
gzip -dc .cache |
    CHMOD='chmod 0444' nofake.sh --error -Rassets.nw -o'<<TOP>>/assets.nw'
@

<<https://www.imagemagick.org/Usage/thumbnails/#favicon snippet>>=
magick image.png -alpha off -resize 256x256 \
    -define icon:auto-resize="256,128,96,64,48,32,16" \
    '<<assets - favicon.ico for pages>>'
@

<<create favicon.ico>>=
magick favicon.png \
    -define icon:auto-resize="64,48,32,16" \
    '<<assets - favicon.ico for pages>>'
@

<<md prefix>>=
2023/2023-10-19_21h40m15_perl·markdown·daringfireball.net/
@

<<md.pl from pages>>=
<<md prefix>>md.pl
@

<<assets.nw - misc>>=
@<<assets - base url>>=
<<base url>>
@@
@<<assets - favicon.ico for top level>>=
favicon.ico
@@
@<<assets - favicon.ico for pages>>=
<<TOP>>/favicon.ico
@@
@<<assets - md.pl for top level>>=
pages/<<md.pl from pages>>
@@
@<<assets - md.pl for pages>>=
<<PAGES>>/<<md.pl from pages>>
@@
@

<<style - body>>=
width: 90ch;
max-width: calc(100vw - 8ch);
margin: 3ch auto 6ch auto;
font-family: Georgia, "Bitstream Charter", serif;
font-size: 14pt;
@

<<style - monospace font>>=
font-family: "Lucida Console", Courier, monospace;
font-size: 14pt;
@

<<assets.nw - style>>=
@<<style>>=
<style>
pre {
    <<style - monospace font>>
}
code {
    <<style - monospace font>>
}
body {
    <<style - body>>
}
</style>
@@
@

<<assets.nw - function escape>>=
@<<asset - function escape>>=
escape(){
    perl -lpe's,&,&amp;,g; s,<,&lt;,g; s,:,&colon;,g; s,^\@,&#x40;,' -- "$@"
}
@@
@

<<assets.nw>>=
This was generated from <<PAGE DIR>>/README.txt, do not change this file.
<<assets.nw - misc>>
<<assets.nw - style>>
<<assets.nw - function escape>>
@

<<template exports 0>>=
'PRIMARY SOURCES' TOP PAGES TITLE 'sh preamble' index.html footer
<<template exports 1>>=
'set $t0' 'generated: $t1 - $t0' 'gen: base url'
<<template exports 2>>=
'create index.html from .index.html' 'update (or not) index.html from .index.html'
<<template exports 3>>=
'update (or not) .index.html from primary sources' 'metas and links'
<<template exports 4>>=
generate render 'print LAST MODIFIED'
<<template exports 0 1 2>>=
<<template exports 0>> <<template exports 1>> <<template exports 2>>
<<template exports 3 4>>=
<<template exports 3>> <<template exports 4>>
<<template exports>>=
<<template exports 0 1 2>> <<template exports 3 4>>
@

This is used by new-item.sh as a partial document.

<<create template>>=
<<sh preamble>>
rm -f template.nw; :>template.nw
nofake-export-chunks.sh <<template exports>> <README.txt >>template.nw
chmod 0444 template.nw
echo 'Created "template.nw".'
@
