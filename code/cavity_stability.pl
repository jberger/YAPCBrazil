#!/usr/bin/env perl

use strict;
use warnings;

use Physics::RayTransfer;

use PDL;
use PDL::Graphics::Prima::Simple;

my $sys = Physics::RayTransfer->new();
$sys->add_mirror(8);                    # R(cm)
$sys->add_space->parameter(sub{shift}); # L
$sys->add_observer;                     # explicit
$sys->add_mirror;

my $L = [ map { $_ / 10 } (0..100) ];

my @w = 
  map { $_->[1]->w(1063e-7) }           # w at 1063nm (IR)
  $sys->evaluate_parameterized($L);

line_plot pdl($L), pdl(\@w);

