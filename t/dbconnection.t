use Mojo::Base -strict;

use Test::More;
use Mojo::Pg;

# Minimal connection string with database
my $pg = Mojo::Pg->new('postgresql://postgres:mysecretpassword@postgresql:5432/postgres');
is $pg->dsn,      'dbi:Pg:dbname=postgres;host=postgresql;port=5432', 'right data source';
is $pg->username, 'postgres',                            'right username';
is $pg->password, 'mysecretpassword',                    'right password';
my $options = {AutoCommit => 1, AutoInactiveDestroy => 1, PrintError => 0,
  RaiseError => 1};
is_deeply $pg->options, $options, 'right options';

ok $pg->db->ping, 'connected';

done_testing();
