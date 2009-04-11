#!/usr/bin/perl

use My::Schema;
#use Cache::Memcached::Fast;
use Cache::Memcached;


my $schema = My::Schema->connect( 'dbi:mysql:dbname=test', 'user01', '');
my $id = 1306;
#$schema->storage->dbh->trace(1);

#$schema->clear_cache_book($id);

my $book = $schema->resultset('Book')->find($id);
print $book->id."  \n";
print $book->author." \n";
$book->author('akihito'.time())." \n";
print $book->update()." \n";

$book = $schema->resultset('Book')->find($id);

print $book->author." \n";
