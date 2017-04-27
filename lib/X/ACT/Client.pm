package X::ACT::Client;
use Mojo::Base -base;
use feature qw(signatures);
no warnings qw(experimental::signatures);
use Mojo::UserAgent;
use Mojo::URL;

has ua       => sub{ Mojo::UserAgent->new };
has user     => sub{ die 'user attribute is required' };
has password => sub{ die 'password attribute is required' };
has url_base => sub{ Mojo::URL->new('http://workshop.barcelona.pm') };
has project  => 'barcelona2016';

sub login($self, $cb=undef) {
    my @form = ( form => {
        credential_0 => $self->user,
        credential_1 => $self->password,
        destination  => '/'. $self->project .'/main'
    });

    if ($cb) {
        return $self->ua->post(
            $self->_url('LOGIN'), @form, sub{ my $tx = pop; $cb->(@_, $self->_login($tx)) }
        );
    }

    $self->_login( $self->ua->post( $self->_url('LOGIN'), @form ) );
}
sub _login($self, $tx) {
    die 'Login has failed' unless $tx->res->code == 302;
    $self;
}

sub userdata($self, $cb=undef) {
    if ($cb) {
        return $self->ua->get( $self->_url('change') => sub{
            my $tx = pop;
            $cb->(@_, _userdata($tx))
        });
    }

    _userdata( $self->ua->get($self->_url('change')) );
}
sub _userdata($tx, $data={}) {
    if ( my $err = $tx->error ) {
      die "$err->{code} response: $err->{message}" if $err->{code};
      die "Connection error: $err->{message}";
    }

    my $dom = $tx->res->dom;

    my $selector = 'input[type="radio"][checked]'
                 . ',input[type="email"]'
                 . ',input[type="text"]';

    $dom->find($selector)->each(sub{
        $data->{$_->attr('name')} = $_->attr('value');
    });
    $dom->find('textarea')->each(sub{
        $data->{$_->attr('name')} = $_->text;
    });
    $dom->find('select')->each(sub{
        $data->{$_->attr('name')} = eval{$_->at('option[selected]')->attr('value')}||'';
    });

    $data;
}

sub _url($self, @path) {
    $self->url_base->clone->path( '/'. join('/', $self->project, @path) );
}

1;
