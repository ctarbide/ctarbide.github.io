
<<references>>=

- *On Subnormal Floating Point and Abnormal Timing*

    - Andrysco, Marc and Kohlbrenner, David and Mowery, Keaton and Jhala,
      Ranjit and Lerner, Sorin and Shacham, Hovav.

    - 2015 IEEE Symposium on Security and Privacy

    - https://homes.cs.washington.edu/~dkohlbre/papers/subnormal-slides.pdf
    
    - https://homes.cs.washington.edu/~dkohlbre/papers/subnormal.pdf

@

<<body in markdown>>=
<h1><<TITLE>></h1>

*Denormals Are Gone* encoding for IEEE754 doubles, because they, the
subnormals, are [not good](#references) anyway.

This is the product of a [detailed observation][FAD] of
IEEE754 format.

[FAD]: <<link to floats and doubles>>

**************** Remapped Ranges

    <<dag64 output>>

**************** Glossary

<<glossary>>

**************** Comparing against original format

<<comparison against original format>>

**************** Features

<<features>>

**************** Key Functions

**** `dag64`

    <<dag64()>>

**** `show_long_bits`

    <<show_long_bits()>>

**************** Sources Listing

<<sources listing>>

<h2 id="references">References</h2>
<<references>>

More details in the link below.
@

<<YEAR>>=
2024
@

<<STAMP>>=
2024-02-21_18h37m27
@

<<ITEM_ID>>=
dag64·dag_encoding·64bit
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

<<sources from dag64.sh>>=
config.nw plumbing.nw common.nw dag64.nw dag64_out.nw
@

<<PRIMARY SOURCES>>=
<<TOP>>/assets.nw README.txt <<sources from dag64.sh>>
@

<<TOP>>=
../../..
@

<<PAGES>>=
../..
@

<<TITLE>>=
ctarbi.de - dag64 · dag encoding · 64bit
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

<<gen: link to floats and doubles>>=
printf '@<<link to floats and doubles>>=\n'
<<TOP>>/bin/find-raw.sh 2024-02 ieee754 floats doubles qnans snans |
    perl -lne'print qq{<<PAGES>>/${_}}'
printf '@\n'
@

<<gen: sources listing>>=
printf '@<<sources listing>>=\n'
for i in <<sources from dag64.sh>> dag64.sh dag64.c; do
    printf -- '- [%s](%s)\n\n' "${i}" "${i}"
done
printf '@\n'
@

<<generate>>=
<<sh preamble>>
<<print LAST MODIFIED>>
cat <<PRIMARY SOURCES>>
<<gen: base url>>
<<gen: link to floats and doubles>>
<<gen: sources listing>>
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

