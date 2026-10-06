#!/usr/bin/perl
use v5.12;
use warnings;

my $lab = "lab5";

# optimized vs unoptimized
`gcc -O0 -S -m32 part_i.c -o $lab-ia.s`;
`gcc -O4 -S -m32 part_i.c -o $lab-ib.s`;
my $ia_full = `cat $lab-ia.s`;
my $ib_full = `cat $lab-ib.s`;
my $i_diff = `diff --side-by-side --width=120 --minimal $lab-ia.s $lab-ib.s`;

# comparing c and cpp
`gcc -O0 -S -m32 helloworld_i.c -o $lab-iia.s`;
my $iia_size = `stat --format=%s $lab-iia.s`;
my $iia_lines = `grep --count -E "^" $lab-iia.s`;
my $iia_hwpart = `grep --text -E --context=4 "LC0" $lab-iia.s`;

`gcc -O0 -S -m32 helloworld_ii.cpp -o $lab-iib.s`;
my $iib_size = `stat --format=%s $lab-iib.s`;
my $iib_lines = `grep --count -E "^" $lab-iib.s`;
my $iib_hwpart = `grep --text -E --context=6 "LC0" $lab-iib.s`;

# using c generated assembly to find code structures
`gcc -O0 -S -m32 while.c -o $lab-iii.s`;

my $report =<<EOF;
Lab data

==============================
Part I

Unoptimized assembly:
$ia_full
~~~~~
Optimized assembly:
$ib_full
~~~~~
A summary of their differences:
$i_diff
==============================
Part II

the C file:
Size: $iia_size
Lines: $iia_lines
The "Hello World" part:
$iia_hwpart
==========
the C++ file:
Size: $iib_size
Lines: $iib_lines
The "Hello World" part:
$iib_hwpart
==============================
Part III

EOF

say $report;
