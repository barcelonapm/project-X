package X::Schema::Result::EventUser;
use strict; use warnings;
use parent 'DBIx::Class';
use utf8;

__PACKAGE__->load_components(qw/ Core /);

__PACKAGE__->table( 'event_user' );
__PACKAGE__->add_columns(
    user_id  => { data_type => 'INT', default_value => 0, is_nullable => 0 },
    event_id => { data_type => 'INT', default_value => 0, is_nullable => 0 },
    role  => {
        data_type     => "ENUM",
        is_nullable   => 0,
        default_value => 'human',
        size          => 6,
        extra         => { list => [qw/ human admin /] }
    },
);

__PACKAGE__->set_primary_key(qw/ event_id user_id /);

__PACKAGE__->belongs_to( user  => 'X::Schema::Result::User', { 'foreign.id' => 'self.user_id' });
__PACKAGE__->belongs_to( event => 'X::Schema::Result::Event', { 'foreign.id' => 'self.event_id' });

1;
