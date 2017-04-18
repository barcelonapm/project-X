package X::Controller::Page;
use Mojo::Base 'Mojolicious::Controller';
use v5.24; use feature qw(signatures);
no warnings qw(experimental::signatures);

sub home($c) {
  # ... something with $c (controller) ?
}

sub about($c) {
  # ... something with $c (controller) ?
}

1;
