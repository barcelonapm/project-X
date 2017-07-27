package X::Schema;
use strict; use utf8;
use parent 'DBIx::Class::Schema';

our $VERSION = '1';

__PACKAGE__->mk_classdata( 'basedir' => 0 );

__PACKAGE__->load_namespaces();
__PACKAGE__->load_components( qw/Schema::Versioned/ );

# add extra attributes to all tables on the schema!
# sub sqlt_deploy_hook {
#     my ($self, $sqlt_schema) = @_;

#     for my $sqlt_table ( $sqlt_schema->get_tables ) {
#         $sqlt_table->extra( mysql_charset => 'utf8' );
#     }
# }

1;
