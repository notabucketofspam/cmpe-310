#!/usr/bin/perl

my $lab = "lab5";

# optimized vs unoptimized
`gcc -O0 -S -m32 part_i.c -o $lab\_ia.s`;
`gcc -O4 -S -m32 part_i.c -o $lab\_ib.s`;
my $ia_full = `cat "$lab"_ia.s`;
my $ib_full = `cat "$lab"_ib.s`;
my $i_diff = `diff -u --tabsize=2 --expand-tabs --minimal "$lab"_ia.s "$lab"_ib.s`;

# comparing c and cpp
`gcc -O0 -S -m32 helloworld_i.c -o $lab\_iia.s`;
my $iia_size = `stat --format=%s "$lab"_iia.s`;
my $iia_lines = `grep --count -E "^" "$lab"_iia.s`;
my $iia_hwpart = `grep --text -E --context=6 "Hello World" "$lab"_iia.s`;

`gcc -O0 -S -m32 helloworld_ii.cpp -o $lab\_iib.s`;
my $iib_size = `stat --format=%s "$lab"_iib.s`;
my $iib_lines = `grep --count -E "^" "$lab"_iib.s`;
my $iib_hwpart = `grep --text -E --context=6 "Hello World" "$lab"_iib.s`;

# using c generated assembly to find code structures
`gcc -O0 -S -m32 while.c -o "$lab"_iii.s`;

my $report =<<EOF
Lab data

==========
Part I

Unoptimized assembly:
$ia_full

Optimized assembly:
$ib_full

A summary of their differences:
$i_diff

==========
Part II

the C file:
Size: $iia_size
Lines: $iia_lines
The "Hello World" part:
$iia_hwpart

the C++ file:
Size: $iib_size
Lines: $iib_lines
The "Hello World" part:
$iib_hwpart

==========
Part III

EOF

say $report;
