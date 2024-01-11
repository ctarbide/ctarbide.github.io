
<<references>>=
- <https://gitlab.common-lisp.net/cmucl/cmucl/-/blob/master/.gitlab-ci.yml>

- <https://github.com/void-linux/void-mklive/blob/master/build-x86-images.sh>

- <https://www.howtogeek.com/455981/how-to-create-a-swap-file-on-linux/>

- <https://docs.voidlinux.org/xbps/repositories/mirrors/changing.html>

- <https://common-lisp.net/project/cmucl/downloads/snapshots/2023/08/>
@

<<void-live iso>>=
void-live-i686-20230628-base.iso
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

<p>You should see the boot screen (choose the default/first option):

![img boot](img-boot.png "boot")

followed by the login screen:

![img login](img-login.png "boot")

Login as `root` with `voidlinux`, then start the installer program
`void-installer`, then follow the installation instructions, this is the
installer main menu:

![img installer](img-installer.png "installer")

Options **Keyboard** and **Network** are straightforward.

For **Source** I always choose **Local** and then update the system later
using `xbps-install -Su`

![img source](img-source.png "source")

Set **Mirror** according to the VM geographical location or use a
global mirror:

![img mirror 1](img-mirror-1.png "mirror-1")

![img mirror 2](img-mirror-2.png "mirror-2")

![img mirror 3](img-mirror-3.png "mirror-3")

![img mirror 4](img-mirror-4.png "mirror-4")

To select another choice of mirror after installation, simply call `xmirror`
on a terminal.

For **Hostname**, **Locale** and **Timezone** I leave them untouched, these
are the default installer settings:

    <<cat /etc/hostname>>

    <<cat /etc/locale.conf>>

    TODO: timezone

Options **RootPassword** and **UserAccount** are also straightforward.

Option **BootLoader** is trivial, there is just one sensible option:

![img bootloader](img-bootloader.png "bootloader")

Now start the most critical settings below, the **Partition** option:

![img partition 1](img-partition-1.png "partition 1")

scroll...

![img partition 2](img-partition-2.png "partition 2")

After following the instructions above for GPT and no UEFI, you should end up
with a this configuration on `cfdisk`:

![img partition 3](img-partition-3.png "partition 3")

Pay close attention to these steps:

![img partition 4](img-partition-4.png "partition 4")

![img partition 5](img-partition-5.png "partition 5")

![img partition 6](img-partition-6.png "partition 6")

I normally do not use a `swap` partition, if the need arises, it is trivial to
setup a swap file on the root partition:

    <<swap on a file>>

Now comes the filesystem setup, **XFS** is a fine choice:

![img filesystem 1](img-filesystem-1.png "file system 1")

Mount it to the root directory:

![img filesystem 2](img-filesystem-2.png "file system 2")

Format and done:

![img filesystem 3](img-filesystem-3.png "file system 3")

Now just **Install**:

![img install 1](img-install-1.png "install 1")

![img install 2](img-install-2.png "install 2")

After installation is complete, choose to not restart, exit installer and
shutdown the VM with `shutdown -h now`.
@

<<xbps-install initial>>=
xbps-install xtools lsof wget curl lynx zip perl rsync unzip
xbps-install zsh mg nano vim tmux rlwrap colordiff groff time
xbps-install patch make git gcc gdb automake autoconf libtool
xbps-install xorg-minimal xorg-input-drivers xorg-video-drivers
xbps-install setxkbmap xauth font-misc-misc terminus-font
xbps-install dejavu-fonts-ttf xterm xrandr xset jwm firefox
xbps-install geany ncurses ncurses-devel libXt-devel
xbps-install motif-devel motif-mwm motif-xmbind xlsfonts
xbps-install font-adobe-100dpi font-adobe-75dpi
@

<<body in markdown>>=
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

After logging in with `root` and the choosen password from installation, it is
advisable to change to a more friendly shell that is available, as shown below:

![img chsh](img-chsh.png "chsh")

Then update the package manager and the system:

    xbps-install -Suy xbps

    xbps-install -uy

After the last command you should end up with something similar to this:

![img system-update](img-system-update.png "system update")

Then install these packages:

    <<xbps-install initial>>

These packages are both very useful and some of them are prerequisite to build CMUCL.

<h2>Configure Environment</h2>

<h2>Extract CMUCL</h2>

Both binaries and sources.

<h2>Build</h2>

<h2>References</h2>
<<references>>
@

<<YEAR>>=
2024
@

<<STAMP>>=
2024-01-08_10h24m46
@

<<ITEM_ID>>=
compiling_cmucl_2023-08_on_a_void-live-i686_vm
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
    git reset --quiet index.html
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
printf '@<<body>>=\n'
nofake --error -R'body in markdown' README.txt | <<assets - md.pl for pages>>
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

