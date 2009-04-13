package My::Schema::Book;

# Created by DBIx::Class::Schema::Loader v0.03008 @ 2009-04-11 22:08:52

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("ResultSetManager","PK::Auto", "Core");
#__PACKAGE__->load_components("Serialize::Storable","ResultSetManager","PK::Auto", "Core");
__PACKAGE__->table("book");
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
  "content",
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
  "book_id",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
);
__PACKAGE__->set_primary_key("id");

sub find :ResultSet {
    my ( $self,$id ) = @_;
    my $schema = $self->result_source->schema;
    my $book = $schema->get_cache_book($id);

    unless ( $book ) {
        ( $book ) = $self->search({id=>$id});
        delete $book->{result_source};
        $schema->set_cache_book($id, $book);
    }

#    $self->new({id=>1306,title=>'hoge'});
#    $book = $schema->get_cache_book($id);
    $book->result_source($self->result_source);
    $book;
}

sub update {
    my ( $self ) = @_;
    my $schema = $self->result_source->schema;
    $self->next::method();
    my $book = $self;
    delete $book->{result_source};
    $schema->set_cache_book($self->id, $book);
    $self;
} 

1;

