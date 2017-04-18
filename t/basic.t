use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('X');
$t->get_ok('/')->status_is(200)->content_like(qr/Project X/, 'Homepage shows our project name');

done_testing();
