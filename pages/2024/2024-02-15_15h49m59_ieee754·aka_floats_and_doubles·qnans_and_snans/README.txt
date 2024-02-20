
<<references>>=
- [Numerical Computing with IEEE Floating Point Arithmetic](https://www.amazon.com/Numerical-Computing-Floating-Point-Arithmetic/dp/0898714826)

- https://en.wikipedia.org/wiki/Machine_epsilon

@

<<TOC>>=
**************** Table Of Contents

- [Basics](#basics)

    - [Output](#basics_output)

<<Section Basics>>=
**************** <span id="basics">Basics</span>

`basics` function from [basics.nw](basics.nw):

    <<void basics(void)>>

`basics` [<span id="basics_output">output</span>](basics_out.nw):

    <<basics output>>

<<TOC>>=
- [Bit Patterns](#bits)

    - [Output](#bits_output)

<<Section Bit Patterns>>=
**************** <span id="bits">Bit Patterns</span>

`bits` function from [bits.nw](bits.nw):

    <<void bits(void)>>

`bits` [<span id="bits_output">output</span>](bits_out.nw):

    <<bits output>>

<<TOC>>=
- [Other sources](#other)

<<Section Other Sources>>=
**************** <span id="other">Other sources</span>

- [config.nw](config.nw)

- [plumbing.nw](plumbing.nw)

- [common.nw](common.nw)

- [basics.sh](basics.sh)

- [bits.sh](bits.sh)

<<TOC>>=
- [Notes](#notes)

<<Section Notes>>=
**************** <span id="notes">Notes</span>

- The `double` type of the C language is known as `binary64` in the IEEE 754
  Standard.

- The same principles shown for `binary64` also applies to `binary32` (c's
  `float` type).

<<TOC>>=
- [References](#references)

<<body in markdown>>=
<h1><<TITLE>></h1>

<<TOC>>

<<Section Basics>>

<<Section Bit Patterns>>

<<Section Other Sources>>

<<Section Notes>>

<h2 id="references">References</h2>

<<references>>

More details in the link below.
@

<<PRIMARY SOURCES>>=
<<TOP>>/assets.nw README.txt config.nw plumbing.nw common.nw basics.nw basics_out.nw bits.nw bits_out.nw
@

<<YEAR>>=
2024
@

<<STAMP>>=
2024-02-15_15h49m59
@

<<ITEM_ID>>=
ieee754·aka_floats_and_doubles
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
if git-file-is-pristine.sh <<PRIMARY SOURCES>>; then
    rm -f .draft
else
    date '+%Y-%m-%d_%Hh%Mm%S' > .draft
    git reset --quiet -- index.html
fi
nofake --error -Rrender <<PRIMARY SOURCES>> | sh
@

<<TOP>>=
../../..
@

<<PAGES>>=
../..
@

<<TITLE>>=
ctarbi.de - ieee754 · aka floats and doubles · qnans and snans
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

