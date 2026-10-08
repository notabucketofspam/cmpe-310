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
my $iii_loop = `grep --text -E --context=5 "cmpl" $lab-iii.s`;
my $iii_max = `cat max.s`;
`gcc -no-pie -nostdlib max.s -o "max"`;
my $iii_max_output = `./max`;

my $report =<<EOF;
<h3>Part I</h3>
Assignment Part IA Code (unoptimized):
<span class="att">$ia_full</span>
Assignment Part IB Code (optimized):
<span class="att">$ib_full</span>
Comparing unoptimized (left) and optimized (right):
<span class="att">$i_diff</span>
<hr/>
<h3>Part II</h3>
1. the C file:
Size: ${iia_size}Lines: ${iia_lines}The "Hello World" part:
<span class="att">$iia_hwpart</span>
2. the C++ file:
Size: ${iib_size}Lines: ${iib_lines}The "Hello World" part:
<span class="att">$iib_hwpart</span>
<hr/>
<h3>Part III</h3>
1. The relevant assembly code for the while loop:
<span class="att">$iii_loop</span>
2. The max.s file:
<span class="att">$iii_max</span>
What's the biggest number?
<span class="att">$iii_max_output</span>
EOF

say $report;
