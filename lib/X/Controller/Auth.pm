package X::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';
use v5.24; use feature qw(signatures);
no warnings qw(experimental::signatures);

sub signin($c) {}

sub signout($c) {
    delete $c->session->{email};
    $c->redirect_to('home');
}

# Bridge to ensure a user is logged in
sub logged_in($c) {
    unless ( $c->user_email ) {
        $c->session->{redir_after_auth} = $c->url_for.'';
        $c->redirect_to('signin');
        return;
    }

    1;
}

# Bridge to ensure a user is not logged in
sub not_logged_in($c) {
    if ( $c->user_email ) {
        $c->redirect_to('home');
        return;
    }

    1;
}

# GET /signin/oauth/:provider
# Handle the login proccess with an OAUTH2 provider
sub oauth_with($c) {
	my ($provider) = grep {$c->stash('provider') eq $_ } $c->oauth_providers->@*;
	return $c->render( text => "OAuth provider '$provider' doesn't exists" ) unless $provider;

	$c->delay(
		sub {
			my $delay = shift;
			$c->oauth2->get_token( $provider => { _oauth_args($provider) } => $delay->begin );
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
    $c->user_email( $email );
    $c->redirect_to( delete $c->session->{redir_after_auth} || 'home' );
}

# Helpers to "Standarize" oauth providers api's for our usecase (getting the email)

sub _api_response_email( $provider, $data ) { ref $data eq 'ARRAY' ? $data->[0]{email} : $data->{email} }

sub _oauth_args( $provider ) {{
    github   => [ scope => 'user:email' ],
    facebook => [ scope => 'email' ],
    google   => [ scope => 'email' ],
}->{$provider}->@*}

sub _oauth_url( $provider, $token ) {{
    github   => "https://api.github.com/user/emails?access_token=$token",
    facebook => "https://graph.facebook.com/me?fields=email&access_token=$token",
    google   => "https://www.googleapis.com/userinfo/v2/me?access_token=$token",
}->{$provider}}

1;
