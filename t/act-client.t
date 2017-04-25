use Test::More;

require_ok( 'X::ACT::Client' );

subtest 'User login and basic data retrieval (sync)' => sub {
    plan( skip_all => 'This tests need ACT credentials as ACT_USER and ACT_PASSWORD' )
        unless $ENV{ACT_USER} && $ENV{ACT_PASSWORD};

    isa_ok(
        my $client = X::ACT::Client->new( user => $ENV{ACT_USER}, password => $ENV{ACT_PASSWORD} ),
        'X::ACT::Client' => 'Create an act client instance'
    );

    ok( $client->login, 'Client can login' );
    ok( my $ud = $client->userdata, '... and get userdata()' );
	ok( $ud->{$_}, "'$_' was retrieved" ) for qw/ email nick_name first_name last_name /;
	for (qw/ tshirt_size web_page pm_group pause_id bio_en company vat address company_url town country gpg_key_id im monk_id nb_family /) {
		diag( "$ENV{ACT_USER} has '$_'" ) if $ud->{$_};
	}
};

subtest 'User login and basic data retrieval (async)' => sub {
    plan( skip_all => 'This tests need ACT credentials as ACT_USER and ACT_PASSWORD' )
        unless $ENV{ACT_USER} && $ENV{ACT_PASSWORD};

    isa_ok(
        my $client = X::ACT::Client->new( user => $ENV{ACT_USER}, password => $ENV{ACT_PASSWORD} ),
        'X::ACT::Client' => 'Create an act client instance'
    );

    Mojo::IOLoop->delay(
        sub { $client->login( shift->begin ) },
        sub {
            my ( $delay, $client ) = @_;
            isa_ok( $client, 'X::ACT::Client', 'Async login() send client to the cb' );
            $client->userdata( $delay->begin );
        },
        sub {
            my $ud = pop;
            isa_ok( $ud, 'HASH', 'Async userdata() send results to the cb' );
            ok( $ud->{$_}, "'$_' was retrieved" ) for qw/ email nick_name first_name last_name /;
        }
    )->catch(sub{ fail(pop) })->wait;
};

done_testing();
