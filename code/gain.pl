#!/usr/bin/env perl

use strict;
use warnings;

use Physics::RayTransfer;

use PDL;
use PDL::Graphics::Prima::Simple;

my $d = 0.2;
my $delta = 0.03;

my $sys = Physics::RayTransfer->new;
$sys->add_mirror;
$sys->add_space($d+$delta);

# c = -1/f, but plot half the focal power F/2
$sys->add_lens->parameter(sub{-0.5*shift}); 
$sys->add_observer;
$sys->add_lens->parameter(sub{-0.5*shift}); # F/2
$sys->add_space($d);
$sys->add_mirror;

my $f = [ map { $_ / 100 } (100..600) ];

my @w = 
  map { $_->[1]->w(1.063e-6) }           # w at 1063nm (IR)
  $sys->evaluate_parameterized($f);

line_plot pdl($f), pdl(\@w);

