
<<references>>=
- http://quantum-mirror.hu/mirrors/pub/slackware/slackware-iso/slackware64-13.37-iso/

- http://quantum-mirror.hu/mirrors/pub/slackware/slackware-iso/slackware-13.37-iso/

@

<<body in markdown>>=

**************************************************************** <<TITLE>>

How to install x86_64 (and [x86](slack32.sh) too) version of Slackware Linux
version 13.37 from 2011.

Some [tips](#tips) below.

The `slack64.sh` that follows is a live literate program [1].

<<htmlified slack64.sh>>

[1]: [literate][lit] program ready for execution, i.e. self-tangling

[lit]: http://www.literateprogramming.com/

**************** Screenshots

![12-11-28](12-11-28.png "12-11-28")

Choose `sda2` for `/` (root) and `sda1` for `/boot`, format both as `ext4`,
install everything ("full" installation).

Installation will take some minutes, progress will be shown and these were
the final dialogs:

![12-19-21](12-19-21.png "12-19-21")

![12-20-12](12-20-12.png "12-20-12")

![12-20-22](12-20-22.png "12-20-22")

![12-20-52](12-20-52.png "12-20-52")

![12-21-02](12-21-02.png "12-21-02")

![12-21-32](12-21-32.png "12-21-32")

![12-22-16](12-22-16.png "12-22-16")

![12-22-29](12-22-29.png "12-22-29")

![12-22-41](12-22-41.png "12-22-41")

![12-23-25](12-23-25.png "12-23-25")

![12-24-21](12-24-21.png "12-24-21")

![12-24-45](12-24-45.png "12-24-45")

![12-25-24](12-25-24.png "12-25-24")

![12-25-56](12-25-56.png "12-25-56")

![12-59-14](12-59-14.png "12-59-14")

![13-00-18](13-00-18.png "13-00-18")


**************** <span id="tips">Tips</span>

<<tips>>

Later on I made a [32-bit version too](slack32.sh), instructions inside.

**************** References

<<references>>

More details in the link below.
@

<<YEAR>>=
2024
@

<<STAMP>>=
2024-02-10_10h47m46
@

<<ITEM_ID>>=
slackware64-13.37_from_2011_on_qemu_v8.1.3
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
<<TOP>>/assets.nw README.txt slack64.sh
@

<<TOP>>=
../../..
@

<<PAGES>>=
../..
@

<<TITLE>>=
ctarbi.de - slackware64 13.37 from 2011 on qemu v8.1.3
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

<<gen: htmlified slack64.sh>>=
<<asset - function escape>>
printf '@<<htmlified slack64.sh>>=\n'
i=slack64.sh
printf '**** [`%s`](%s):\n\n' "${i}" "${i}"
printf '<pre style="margin-left: 3ch;"><code>'
escape "${i}"
printf '</code></pre>\n'
printf '@\n'
@

<<generate>>=
<<sh preamble>>
<<print LAST MODIFIED>>
cat <<PRIMARY SOURCES>>
<<gen: base url>>
<<gen: htmlified slack64.sh>>
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
