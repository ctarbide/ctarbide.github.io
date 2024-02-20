#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
SH=${SH:-sh}; export SH
PERL=${PERL:-perl}; export PERL
printf -- '[%s]\n' "${0}"
exec nofake-exec.sh --error -Rmain "$@" -- "${SH}" -eu
exit 1

This is a live literate program.

<<try this>>=
seq 3 | ./hello-sh-perl.sh a 'b c' ' ${d} '
@

<<data>>=
hello world!
@

<<main>>=
thisprog=${1} # the initial script
mainprog=${0}
set -- "${thisprog}" --ba-- "${mainprog}" "$@" --ea--
printf -- '[%s] -> [%s]\n' "${thisprog}" "${mainprog}"
[ -t 0 ] || nofake-exec.sh -R'stdin is non-tty' "${thisprog}" -- "${PERL}" -wl
nofake --error -Rdata "${thisprog}" | nofake-exec.sh --error -Rperl "$@" -- "${PERL}" -w
@

<<perl>>=
my ($mainprog, $thisprog) = splice(@ARGV, 0, 2);
my $perlprog = $0;
print("[${thisprog}] -> [${mainprog}] -> [${perlprog}]\n");
print(do{local$/;<STDIN>});
print("args: '" . join("' '", @ARGV) . "'\n") if @ARGV;
@

<<stdin is non-tty>>=
while (<>) {
    chomp;
    s,^,STDIN: ,;
    print;
}
@
