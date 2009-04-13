package My::Schema::BookList;

# Created by DBIx::Class::Schema::Loader v0.03008 @ 2009-04-11 22:08:52

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("PK::Auto", "Core");
__PACKAGE__->table("book_list");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "MEDIUMINT",
    default_value => undef,
    is_nullable => 0,
    size => 9,
  },
  "title",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65_535,
  },
  "author",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65_535,
  },
  "link",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65_535,
  },
  "xhtml",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65_535,
  },
);
__PACKAGE__->set_primary_key("id");

1;

