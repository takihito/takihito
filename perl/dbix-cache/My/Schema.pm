package My::Schema;

# Created by DBIx::Class::Schema::Loader v0.03008 @ 2009-04-11 22:08:52

use strict;
use warnings;

use base 'DBIx::Class::Schema';
use Cache::Memcached::Fast;
#use Cache::Memcached;

__PACKAGE__->load_classes;
__PACKAGE__->mk_classdata( _cache_book => '' );

sub connect {
    my $self = shift->next::method(@_);
    my $cache = new Cache::Memcached::Fast({ servers => ['127.0.0.1:11211'], namespace=>'book:'});
#    my $cache = new Cache::Memcached({ servers => ['127.0.0.1:11211'], namespace=>'book:'});
    $self->_cache_book($cache);
    $self;
}

sub set_cache_book {
    my ( $self, $key, $value ) = @_;
    my $cache = $self->_cache_book();
    $cache->set($key,$value);
}

sub get_cache_book {
    my ( $self, $key ) = @_;
    my $cache = $self->_cache_book();
    $cache->get($key);
}

sub clear_cache_book {
    my ( $self, $key ) = @_;
    my $cache = $self->_cache_book();
    $cache->delete($key);
}

1;

