#!/usr/bin/env perl

# very specific improvements

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use 5.008; # perl v5.8.0 was released on July 18, 2002
use strict;
use warnings FATAL => qw{uninitialized void inplace};

local $\ = "\n";

my @header = (0, (3) x 15, (2) x (63 - 15), (1) x (128 - 63));

sub autoheader ($$) {
    my ($markup, $title)= @_;
    my $n = $header[length $markup];
    if ($n) {
        $title =~ s,^\s*|\s*$,,g;
        if ($title) {
            ("#" x $n) . " ${title}";
        } else {
            ("#" x $n) . ' (untitled)';
        }
    } else {
        $markup . $title;
    }
}

while (<>) {
    chomp;
    s{^ ( \*{64} | \*{16} | \*{4} ) (\s .* $ | $) }{
        autoheader(${1}, ${2});
    }xie;
    s{
        (^ \s* | [^\w<"'] )
        ( https? :// [\w\-.%]+ \. \w{2,3} / (?: [\w\-.%/?=&\#+]* [\w/] )? )
        ( [^\w>"'] | \s* $)
    }{${1}<${2}>${3}}xg;
    print;
}
