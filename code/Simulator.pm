package Simulator;

sub import {
  require Import::Into;
  Simulator::Types->import::into(scalar(caller), ':all');
}

use Moops;

library Types
  extends Types::Standard
  declares Article, Coordinate, Force, Simulator {

  class_type Coordinate, { class => 'Simulator::Coordinate' };
  coerce Coordinate, 
    from Num, 
    via { 'Simulator::Coordinate'->new( current => $_ ) };

  class_type Force,     { class => 'Simulator::Force' };
  class_type Article,   { class => 'Simulator::Article' };
  class_type Simulator, { class => 'Simulator::Engine' };
}

class Coordinate types Types {
  has 'current' => ( isa => Num, is => 'rw', required => 1, trigger => sub { shift->_append(@_) });
  has 'history' => ( isa => ArrayRef[Num], is => 'lazy', builder => sub { [] } );

  method _append (Num $new)   { push @{ $self->history }, $new }
  method change  (Num $delta) { $self->current( $self->current + $delta ) }
}

class Force types Types {
  has 'strength' => ( isa => Num,     is => 'rw', default  => 0 );
  has 'affect'   => ( isa => CodeRef, is => 'ro', builder => sub { sub { shift->strength } } );
  method evaluate (Article $article) { $self->affect->($self, $article) }
}

class Article types Types :ro {
  has 'mass' => ( isa => Num, required => 1 );
  has '_x'   => ( 
    isa => Coordinate, coerce => 1, default => 0, init_arg => 'x',
    handles => { x => 'current', move => 'change', x_history => 'history' },
  );
  has '_vx'  => ( 
    isa => Coordinate, coerce => 1, default => 0, init_arg => 'vx',
    handles => { vx => 'current', accelerate => 'change', vx_history => 'history' },
  );
}

class Engine types Types {
  use List::Util 'sum';

  has 'start'  => ( isa => Num, is => 'rw', default => 0 );
  has 'end'    => ( isa => Num, is => 'rw', default => 1 );
  has 'steps'  => ( isa => Num, is => 'rw', default => 100 );

  has 'step'   => ( isa => Num, is => 'lazy' );
  has '_time'  => ( 
    isa => Coordinate, coerce => 1, is => 'lazy', init_arg => 'time', 
    handles => { time => 'current', tick => 'change', time_history => 'history' },
  );

  has 'articles' => ( isa => ArrayRef[Article], is => 'ro', builder => sub{ [] } );
  has 'forces'   => ( isa => ArrayRef[Force],   is => 'ro', builder => sub{ [] } );

  method _build_step  () { ($self->end - $self->start) / $self->steps }
  method _build__time () { $self->start }

  method evolve (Article $article) {
    my $dt = $self->step;
    my $vx = $article->vx;

    my $force = sum map { $_->evaluate($article) } @{ $self->forces };
    my $acc = $force / ($article->mass);

    $article->accelerate( $acc * $dt );
    $article->move( $vx * $dt );
  }

  method run () {
    while ($self->time < $self->end) {
      $self->evolve( $_ ) for @{ $self->articles };
      $self->tick( $self->step );
    }
  }
}

1;

