package X::Schema::Component::TimestampFields;

use strict;
use warnings;
use utf8;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/ TimeStamp Core /);

sub add_timestamp_fields {
    my $class = shift;

    $class->add_columns(
        created => { data_type => 'datetime', set_on_create => 1, },
        updated => { data_type => 'datetime', set_on_create => 1, set_on_update => 1, },
    );
}

1;
