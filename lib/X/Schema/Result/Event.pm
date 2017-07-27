package X::Schema::Result::Event;
use strict; use warnings;
use utf8;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/
    +X::Schema::Component::TimestampFields
    Core
/);

__PACKAGE__->table( 'event' );
__PACKAGE__->add_columns(
    id          => { data_type => 'INT', is_nullable => 0, is_auto_increment => 1 },
    name        => { data_type => 'VARCHAR', default_value => "", is_nullable => 1, size => 64 },
    description => { data_type => 'text', default_value => '', is_nullable => 1 },
    start_date  => { data_type => 'datetime', is_nullable => 1 },
    end_date    => { data_type => 'datetime', is_nullable => 1 },
    cfp_limit   => { data_type => 'datetime', is_nullable => 1 },
);

__PACKAGE__->add_timestamp_fields();
__PACKAGE__->set_primary_key( 'id' );

__PACKAGE__->has_many( talks => 'X::Schema::Result::Talk', { 'foreign.event_id' => 'self.id' } );

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;

    $sqlt_table->add_index( name => 'start_idx', fields => [qw/ start_date /] );
}

1;
