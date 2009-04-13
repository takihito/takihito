package My::Schema::Test;

# Created by DBIx::Class::Schema::Loader v0.03008 @ 2009-04-11 22:08:52

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("PK::Auto", "Core");
__PACKAGE__->table("test");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => "", is_nullable => 0, size => 11 },
  "data1",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65_535,
  },
  "data2",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 20 },
  "reg_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
);
__PACKAGE__->set_primary_key("id");

1;

