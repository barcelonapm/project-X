package X::Schema::Result::Talk;

use strict;
use warnings;
use utf8;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/
    +X::Schema::Component::TimestampFields
    Core
/);

__PACKAGE__->table( 'talk' );
__PACKAGE__->add_columns(
    id       => { data_type => 'INT', is_nullable => 0, is_auto_increment => 1 },
    user_id  => { data_type => 'INT', is_nullable => 1 },
    event_id => { data_type => 'INT', is_nullable => 1 },
    title    => { data_type => 'VARCHAR', default_value => "", is_nullable => 1, size => 64 },
    description => { data_type => 'text', default_value => '', is_nullable => 1 },
    url      => { data_type => 'VARCHAR', default_value => "", is_nullable => 1, size => 255 },
    duration => { data_type => 'INT', is_nullable => 0 },
    lang     => { data_type => 'VARCHAR', default_value => "", is_nullable => 1, size => 32 },
    status   => {
        data_type     => "ENUM",
        default_value => "open",
        is_nullable   => 0,
        size          => 6,
        extra         => { list => [qw/ new accepted rejected /] }
    },
);

__PACKAGE__->add_timestamp_fields();
__PACKAGE__->set_primary_key( 'id' );

__PACKAGE__->belongs_to( user => 'X::Schema::Result::User', { 'foreign.id' => 'self.user_id' });
__PACKAGE__->belongs_to( user => 'X::Schema::Result::Event', { 'foreign.id' => 'self.event_id' });

__PACKAGE__->has_many( 'talk_attendees', 'X::Schema::Result::UserTalk', { 'foreign.talk_id' => 'self.id' } );
__PACKAGE__->many_to_many( 'attendees', 'talk_attendees', 'user' );

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;

    $sqlt_table->add_index( name => 'user_idx', fields => [qw/ user_id /] );
    $sqlt_table->add_index( name => 'event_idx', fields => [qw/ event_id /] );
    $sqlt_table->add_index( name => 'status_idx', fields => [qw/ status /] );
}

1;

