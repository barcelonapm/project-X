use Mojo::Base -strict;

use Test::More;
use Mojo::Pg;

# Minimal connection string with database
my $pg = Mojo::Pg->new("postgresql://$ENV{'DB_USER'}:$ENV{'DB_PASS'}\@$ENV{'DB_HOST'}:5432/postgres");
is $pg->dsn,      "dbi:Pg:dbname=postgres;host=$ENV{'DB_HOST'};port=5432",    'right data source';
is $pg->username, "$ENV{'DB_USER'}",                                          'right username';
is $pg->password, "$ENV{'DB_PASS'}",                                          'right password';

my $options = {AutoCommit => 1, 
               AutoInactiveDestroy => 1, 
               PrintError => 0,
               RaiseError => 1
              };

is_deeply $pg->options, $options, 'right options';

ok $pg->db->ping, 'connected';

done_testing();
