package X::Schema::Result::User;
use strict;
use warnings;

use parent 'DBIx::Class';
use utf8;

__PACKAGE__->load_components(qw/ EncodedColumn Core /);

__PACKAGE__->table( 'user' );
__PACKAGE__->add_columns(
    id    => { data_type => 'INT', is_nullable => 0, is_auto_increment => 1 },
    email => { data_type => 'VARCHAR', default_value => "", is_nullable => 0, size => 255 },
    password => {
        data_type           => 'VARCHAR',
        default_value       => '',
        is_nullable         => 0,
        size                => 40 + 10,
        encode_column       => 1,
        encode_class        => 'Digest',
        encode_args         => { algorithm => 'SHA-1', format => 'hex', salt_length => 10 },
        encode_check_method => 'check_password',
    },
    name   => { data_type => 'VARCHAR', default_value => "", is_nullable => 1, size => 64 },
    tshirt => { data_type => 'VARCHAR', default_value => "", is_nullable => 1, size => 32 },
    bio    => { data_type => 'text', default_value => '', is_nullable => 1 },
    pause  => { data_type => 'VARCHAR', default_value => "", is_nullable => 1, size => 64 },
    url    => { data_type => 'VARCHAR', default_value => "", is_nullable => 1, size => 255 },
    role  => {
        data_type     => "ENUM",
        is_nullable   => 0,
        default_value => 'human',
        size          => 6,
        extra         => { list => [qw/ human admin /] }
    },
);

__PACKAGE__->set_primary_key( 'id' );
__PACKAGE__->add_unique_constraint( 'email', ['email'] );

__PACKAGE__->has_many( 'talks', 'X::Schema::Result::Talk', { 'foreign.user_id' => 'self.id' } );

__PACKAGE__->has_many( 'user_talks', 'X::Schema::Result::UserTalk', { 'foreign.user_id' => 'self.id' } );
__PACKAGE__->many_to_many( 'attending', 'user_talks', 'talk' );

__PACKAGE__->has_many( 'user_events', 'X::Schema::Result::EventUser', { 'foreign.user_id' => 'self.id' } );
__PACKAGE__->many_to_many( 'events', 'user_events', 'event' );

sub is_admin { shift->role eq 'admin' }

1;
