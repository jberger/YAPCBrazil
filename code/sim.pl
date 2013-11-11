#!/usr/bin/env perl

use strict; use warnings;

use Simulator;
use PDL;
use PDL::Graphics::Prima::Simple;

my $article = Article->new( mass => 2 );

my $up   = Force->new( strength => 2 );

my $down = Force->new(
  strength => -30,
  affect => sub {
    my ($self, $item) = @_;
    return 0 if ($item->x < 0.1);
    return $self->strength;
  },
);

my $sim = Simulator->new(
  end => 5,
  articles => [ $article ],
  forces   => [ $up, $down ],
);

$sim->run;

my $time = pdl $sim->time_history;
my $x    = pdl $article->x_history;

line_plot($time, $x);
