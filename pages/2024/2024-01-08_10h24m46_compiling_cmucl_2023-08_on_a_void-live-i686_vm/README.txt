
<<references>>=
- <https://gitlab.common-lisp.net/cmucl/cmucl/-/blob/master/.gitlab-ci.yml>

- <https://github.com/void-linux/void-mklive/blob/master/build-x86-images.sh>

- <https://www.howtogeek.com/455981/how-to-create-a-swap-file-on-linux/>

- <https://docs.voidlinux.org/xbps/repositories/mirrors/changing.html>

- <https://common-lisp.net/project/cmucl/downloads/snapshots/2023/08/>
@

<<void-live iso>>=
${HOME}/void-live-i686-20230628-base.iso
@

<<base image>>=
void-live-i686--base.qcow2
@

<<create base image>>=
qemu-img create -f qcow2 "<<base image>>" 20G
@

image will be backed by base image

<<image>>=
void-live-i686.qcow2
@

<<run qemu for installation>>=
qemu-system-i386 -m 2048 \
    -hda "<<base image>>" \
    -cdrom "<<void-live iso>>" \
    -boot d
@

<<run qemu>>=
qemu-system-i386 -m 2048 -hda "<<base image>>"
@

<<swap on a file>>=
swapon --show
dd iflag=fullblock if=/dev/zero of=/swapfile bs=4096 count=524288 2>/dev/null
mkswap /swapfile
chmod 0600 /swapfile
swapon /swapfile
# then add this to /etc/fstab: "/swapfile none swap sw 0 0"
@

<<cat /etc/hostname>>=
# cat /etc/hostname
void
@

<<cat /etc/locale.conf>>=
# cat /etc/locale.conf
LANG=C.UTF-8
LC_COLLATE=C
@

<<Install OS>>=

<h2>Install OS</h2>

Start `qemu` to install from `ISO` image (tested with `QEMU emulator version 8.1.3`):

    <<run qemu for installation>>

<p>You should see these:

- img boot

- img login

Login as `root` with `voidlinux`, then start the installer program
`void-installer`, then follow the installation instructions.

Options **Keyboard** and **Network** are straightforward.

For **Source** I always choose **Local** and then update the system later
using `xbps-install -Su`

Set **Mirror** according to the virtual machine geographical location or use a
global mirror:

- img mirror

To select another choice of mirror after installation, simply call `xmirror`
on a terminal.

The most important settings are shown below:

- img cfdisk

- img file systems

I normally do not use a `swap` partition, if the need arises, it is trivial to
setup a swap file on the root partition:

    <<swap on a file>>

Default installer settings:

    <<cat /etc/hostname>>

    <<cat /etc/locale.conf>>

Change them if you will, choose the **BootLoader** to ``/dev/sda`` then
proceed to install.
@

<<body>>=
<h1><<TITLE>></h1>

<h2>Download assets</h2>

- <https://repo-default.voidlinux.org/live/current/void-live-i686-20230628-base.iso>

- <https://common-lisp.net/project/cmucl/downloads/snapshots/2023/08/cmucl-2023-08-x86-linux.tar.bz2>

- <https://common-lisp.net/project/cmucl/downloads/snapshots/2023/08/cmucl-src-2023-08.tar.bz2>

<h2>Prepare VM</h2>

    <<create base image>>

<<Install OS>>

<h2>Start the System</h2>

    <<run qemu>>

<h2>Install Packages</h2>

<h2>Configure Environment</h2>

<h2>Extract CMUCL</h2>

Both binaries and sources.

<h2>Build</h2>

<h2>References</h2>
<<references>>
@

<<PRIMARY SOURCES>>=
<<TOP>>/assets.nw README.txt
@

<<URL_PREFIX>>=
https://ctarbide.github.io/pages/2024
@

<<TOP>>=
../../..
@

<<PAGES>>=
../..
@

<<STAMP>>=
2024-01-08_10h24m46
@

<<ITEM_ID>>=
compiling_cmucl_2023-08_on_a_void-live-i686_vm
@

<<CANONICAL_URL>>=
<<URL_PREFIX>>/<<STAMP>>_<<ITEM_ID>>/index.html
@

<<TITLE>>=
ctarbi.de - <<ITEM_ID>>
@

<<sh preamble>>=
#!/bin/sh
set -eu
@

<<print LAST MODIFIED>>=
if git diff-index --quiet HEAD README.txt; then
    FORMAT='format:%B %e, %Y at %T UTC' git-last-modified.sh README.txt | perl \
        -lne'print(qq{@<<LAST MODIFIED@>>=\n${_}\n@\n})'
else
    date '+%Y-%m-%d_%Hh%Mm%S' > .draft
    last-modified.sh README.txt | perl -MPOSIX=strftime \
        -lne'print(strftime(qq{@<<LAST MODIFIED@>>=\n%B %e, %Y (DRAFT)\n@\n}, gmtime($_)))'
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
printf '@<<body (md)>>=\n'
nofake -Rbody README.txt | <<assets - md.pl for pages>>
printf '@\n'
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
nofake -Rgenerate <<PRIMARY SOURCES>> | sh | CHMOD='chmod 0444' nofake.sh --error -Rindex.html -o.index.html
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
<<body (md)>>
<<footer>>
@

<<metas and links>>=
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=0.6">
<link rel="canonical" href="<<CANONICAL_URL>>">
<link rel="icon" href="<<assets - favicon.ico for pages>>" type="image/x-icon">
@

<<style>>=
<style>
body {
    width: 90ch;
    max-width: calc(100vw - 4em);
    margin: 2em auto 0 auto;
}
</style>
@

<<footer>>=
<p> This <a href="README.txt">page</a> was last modified on <<LAST MODIFIED>>.
@

<<*>>=
nofake --error -Rrender <<PRIMARY SOURCES>>
@
