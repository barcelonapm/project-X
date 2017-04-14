package X;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $app = shift;
    $app->setup_plugins;
    $app->setup_routes;
}

# Initialize all routes and route-rules...
sub setup_routes {
    my $app = shift;

    my $r = $app->routes;

    $r->get('/')->to('root#welcome');
    $r->get('/_env')->to( cb => sub { shift->render( json => \%ENV ) } );


    $r->get('/signin')->to('auth#signin');
    $r->get('/signin/oauth/:provider')->to('auth#oauth_with')->name('oauth_with');
}

# Initialize app plugins...
sub setup_plugins {
    my $app = shift;

    $app->setup_oauth_providers;
}

# Initialize OAuth2 plugin picking up providers from %ENV
sub setup_oauth_providers {
    my $app = shift;
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

1;
