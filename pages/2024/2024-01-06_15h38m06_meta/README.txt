
<<references>>=
- https://stackoverflow.com/questions/5641997/is-it-necessary-to-write-head-body-and-html-tags

    - context: html body tag not required

- https://gist.github.com/pfig/1808188

    - context: imagemagick favicon generator

    - https://www.imagemagick.org/Usage/thumbnails/#favicon

- https://www.atomic-scale-physics.de/lattice/struk.picts/bh.s.png
@

<<*>>=
CHMOD='chmod 0444' nofake.sh --error -Rassets.nw -o'<<TOP>>/assets.nw' README.txt
nofake --error -Rrender README.txt
@

<<URL_PREFIX>>=
https://ctarbide.github.io/pages/2024
@

<<TOP>>=
../../..
@

<<STAMP>>=
2024-01-06_15h38m06
@

<<ITEM_ID>>=
meta
@

<<CANONICAL_URL>>=
<<URL_PREFIX>>/<<STAMP>>_<<ITEM_ID>>/index.html
@

<<print LAST MODIFIED>>=
last-modified.sh README.txt | perl -MPOSIX=strftime \
    -lne'print(strftime(qq{@<<LAST MODIFIED@>>=\n%B %e, %Y\n@\n}, gmtime($_)))'
@

<<render>>=
(
    <<print LAST MODIFIED>>
    cat '<<TOP>>/assets.nw' README.txt
) | CHMOD='chmod 0444' nofake.sh --error -Rindex.html -oindex.html
@

<<index.html>>=
<!DOCTYPE html>
<html lang="en">
<title>ctarbi.de - <<STAMP>> - <<ITEM_ID>></title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=0.6">
<link rel="canonical" href="<<CANONICAL_URL>>">
<link rel="icon" href="<<assets - favicon.ico for pages>>" type="image/x-icon">
<style>
body {
    width: 90ch;
    max-width: calc(100vw - 4em);
    margin: 2em auto 0 auto;
}
</style>
<h1>Sample Document</h1>
<p>
    This is just a sample paragraph.
<p>
    This <a href="README.txt">page</a> was
    last modified on <<LAST MODIFIED>>.
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

<<assets.nw>>=
@<<assets - favicon.ico for pages>>=
<<TOP>>/favicon.ico
@@
@
