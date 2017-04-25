package X;
use Mojo::Base 'Mojolicious';
use v5.24; use feature qw(signatures);
no warnings qw(experimental::signatures);

# This method will run once at server start
sub startup($app) {
    $app->setup_plugins;
    $app->setup_routes;
}

# Initialize all routes and route-rules...
sub setup_routes($app) {
    my $r    = $app->routes;
    my $auth = $r->under('/')->to('auth#logged_in');
    my $anon = $r->under('/')->to('auth#not_logged_in');

    $r->get('/')->to('page#home')->name('home');

    $anon->get('/signin')->to('auth#signin');
    $anon->get('/signin/oauth/:provider')->to('auth#oauth_with')->name('oauth_with');
    $anon->post('/signin/act')->to('auth#with_act')->name('signin_with_act');

    $auth->get('/about')->to('page#about')->name('about');
    $auth->get('/signout')->to('auth#signout')->name('signout');

    # Debug routes...
    $r->get('/_env')->to( cb => sub { shift->render( json => \%ENV ) } ) if $app->mode eq 'development';
}

# Initialize app plugins...
sub setup_plugins($app) {
    $app->setup_oauth_providers;
    $app->setup_helpers;
}

# Initialize OAuth2 plugin picking up providers from %ENV
sub setup_oauth_providers($app) {
    my $providers = {};

    for my $provider (qw/ facebook google github /) {
        my $p = uc($provider);
        if ( $ENV{"OAUTH_${p}_KEY"} && $ENV{"OAUTH_${p}_SECRET"} ) {
            $providers->{$provider} = {
                key    => $ENV{"OAUTH_${p}_KEY"},
                secret => $ENV{"OAUTH_${p}_SECRET"},
            };
        }
    }

    $app->plugin( OAuth2 => $providers ) if keys $providers->%*;
    $app->helper( oauth_providers => sub{[ keys $providers->%* ]});
}

sub setup_helpers {
    my $app = shift;

    $app->helper( 'user_email' => sub { shift->session( 'email', shift//() ) } );
}

1;
