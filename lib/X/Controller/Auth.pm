package X::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';
use v5.24; use feature qw(signatures);
no warnings qw(experimental::signatures);

sub signin( $c ) {}

sub oauth_with( $c ) {
	my ($provider) = grep {$c->stash('provider') eq $_ } $c->oauth_providers->@*;
	return $c->render( text => "OAuth provider '$provider' doesn't exists" ) unless $provider;

	$c->delay(
		sub {
			my $delay = shift;
			$c->oauth2->get_token( $provider => {
                redirect_uri => $c->url_with->to_abs, _oauth_args($provider)
            } => $delay->begin);
		},
		sub {
			my ($delay, $err, $data) = @_;
			return $c->render( json => { error => $err } ) unless $data->{access_token};
            $c->ua->get( _oauth_url($provider => $data->{access_token}) => $delay->begin )
		},
        sub {
			my ($delay, $tx) = @_;
            $c->_authorized( _api_response_email( $provider => $tx->res->json ) );
        }
	);
}

# A user was authorized by some provider: Keep user on a DB?
sub _authorized( $c, $email ) {
    $c->render( json => { email => $email } );
}

# Helpers to "Standarize" oauth providers api's for our usecase (getting the email)

sub _api_response_email( $provider, $data ) { $data->[0]{email} }

sub _oauth_args( $provider ) {{
    github   => [ scope => 'user:email' ],
    facebook => [],
    google   => [],
}->{$provider}->@*}

sub _oauth_url( $provider, $token ) {{
    github   => "https://api.github.com/user/emails?access_token=$token",
    facebook => "$token",
    google   => "$token",
}->{$provider}}

1;
