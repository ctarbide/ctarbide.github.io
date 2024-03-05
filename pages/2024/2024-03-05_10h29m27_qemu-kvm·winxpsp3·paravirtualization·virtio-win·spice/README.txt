
<<tested with qemu version>>=
QEMU emulator version 8.1.3
Copyright (c) 2003-2023 Fabrice Bellard and the QEMU Project developers
@

<<spice spicy version>>=
spicy 0.42
@

<<file>>=
/libvirt-storage/winxp_sp3_x86_vs6sp6.qcow2
@

<<other iproute2 interesting commands>>=
ip link show dev tap99
ip -brief link
ip -brief addr
ip route
@

<<tap config>>=
LOCAL_INTERFACE=tap99
LOCAL_IP=192.168.99.1
@

<<tap setup - run as root>>=
<<sh preamble>>
<<tap config>>
if ! ip link show "${LOCAL_INTERFACE}"; then
    ip tuntap add "${LOCAL_INTERFACE}" mode tap
    ip addr flush dev "${LOCAL_INTERFACE}"
    ip link set "${LOCAL_INTERFACE}" up
    ip address add "${LOCAL_IP}" dev "${LOCAL_INTERFACE}"
    ip route add 192.168.99.0/24 dev tap99
fi
@

<<tap delete - run as root>>=
<<sh preamble>>
<<tap config>>
if ip link show "${LOCAL_INTERFACE}"; then
    ip link set "${LOCAL_INTERFACE}" down
    ip link delete "${LOCAL_INTERFACE}"
fi
@

Most of these qemu settings came from 'ps axf' while using virt-manager.

<<tap network - virtio-net-pci>>=
set -- "$@" -netdev '{"type":"tap","ifname":"tap99","id":"tapnet99","script":"no","downscript":"no"}'
set -- "$@" -device '{"driver":"virtio-net-pci","netdev":"tapnet99","id":"net0","mac":"52:54:00:69:c7:22"}'
@

<<spice server and devices>>=
set -- "$@" -spice port=5900,addr=127.0.0.1,disable-ticketing=on
set -- "$@" -device virtio-serial -chardev spicevmc,id=vdagent,debug=0,name=vdagent
set -- "$@" -device virtserialport,chardev=vdagent,name=com.redhat.spice.0
@

<<spice audio>>=
set -- "$@" -audiodev '{"id":"audio1","driver":"spice"}'
set -- "$@" -device '{"driver":"AC97","id":"sound0","audiodev":"audio1"}'
@

<<machine settings>>=
set -- "$@" -machine 'pc-i440fx-8.1,usb=off,vmport=off,dump-guest-core=off,memory-backend=pc.ram,hpet=off,acpi=on'
set -- "$@" -accel 'kvm'
set -- "$@" -cpu 'host,migratable=on'
set -- "$@" -m 'size=2097152k'
set -- "$@" -object '{"qom-type":"memory-backend-ram","id":"pc.ram","size":2147483648}'
set -- "$@" -overcommit 'mem-lock=off'
set -- "$@" -smp '2,sockets=2,cores=1,threads=1'
@

<<guest name>>=
winxpsp3x86
@

<<launch from README.txt>>=
nofake-exec.sh --error -Rrun.sh -orun.sh README.txt -- sh -eu
@

<<run.sh>>=
<<sh preamble>>

set --

<<machine settings>>
<<tap network - virtio-net-pci>>
<<spice server and devices>>
<<spice audio>>

set -- "$@" -name <<guest name>>
set -- "$@" -monitor stdio
set -- "$@" -boot order=dc
set -- "$@" -vga qxl

exec qemu-system-x86_64 "$@" <<file>>
@

<<spicy title>>=

<<launch spice viewer>>=
spicy -h 127.0.0.1 -p 5900 --title '<<guest name>>'
@

<<references>>=
- https://www.spice-space.org/spice-user-manual.html

- https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.248-1/virtio-win-0.1.248.iso

    - latest drivers

- https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-0.141/spice-guest-tools-0.141.exe

@

<<body in markdown>>=
<h1><<TITLE>></h1>

**************** Tested With

**** qemu

    <<tested with qemu version>>

**** spicy

    <<spice spicy version>>

**************** Tun/Tap Setup

**** Setup

    <<tap setup - run as root>>

**** Cleanup

    <<tap delete - run as root>>

**** Useful

    <<other iproute2 interesting commands>>

**************** Run Script

    <<run.sh>>

**** Tip

    <<launch from README.txt>>

**************** Spicy Viewer

    <<launch spice viewer>>

**************** Screenshots

![devmgmt](devmgmt.png "devmgmt")

![netconfig](netconfig.png "netconfig")

![ping-host](ping-host.png "ping-host")

![ping-guest](ping-guest.png "ping-guest")

<h2>References</h2>
<<references>>

More details in the link below.
@

<<YEAR>>=
2024
@

<<STAMP>>=
2024-03-05_10h29m27
@

<<ITEM_ID>>=
qemu-kvm·winxpsp3·paravirtualization·virtio-win·spice
@

<<ITEM_URI>>=
qemu-kvm%C2%B7winxpsp3%C2%B7paravirtualization%C2%B7virtio-win%C2%B7spice
@

<<PAGE DIR>>=
pages/<<YEAR>>/<<STAMP>>_<<ITEM_ID>>
@

<<PAGE URI>>=
pages/<<YEAR>>/<<STAMP>>_<<ITEM_URI>>
@

<<URL PREFIX>>=
<<assets - base url>><<PAGE URI>>
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
ctarbi.de - qemu-kvm · winxpsp3 · paravirtualization · virtio-win · spice
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
