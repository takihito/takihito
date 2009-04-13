#!/usr/bin/perl

use My::Schema;
use My::Schema::Book;
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

#my ( $book1 ) = $schema->resultset('Book')->search({id=>$id});
#my $cache = new Cache::Memcached({ servers => ['127.0.0.1:11211'], namespace=>'sample:'});
#$cache->set('book',$book1);
#my $book2 = $cache->get('book');
#$book2->author('akihitozz'.time());
#$book2->update();
#print "id ".$book2->author." -------- \n";

