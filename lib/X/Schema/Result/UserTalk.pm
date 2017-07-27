package X::Schema::Result::UserTalk;
use strict; use warnings;
use parent 'DBIx::Class';
use utf8;

__PACKAGE__->load_components(qw/ Core /);

__PACKAGE__->table( 'user_talk' );
__PACKAGE__->add_columns(
    user_id => { data_type => 'INT', default_value => 0, is_nullable => 0 },
    talk_id => { data_type => 'INT', default_value => 0, is_nullable => 0 },
    created => { data_type => 'datetime', set_on_create => 1, },
);

__PACKAGE__->set_primary_key(qw/ user_id talk_id /);
__PACKAGE__->resultset_attributes({ order_by => [ 'created' ] });

__PACKAGE__->belongs_to( user => 'X::Schema::Result::User', { 'foreign.id' => 'self.user_id' });
__PACKAGE__->belongs_to( talk => 'X::Schema::Result::Talk', { 'foreign.id' => 'self.talk_id' });

1;
