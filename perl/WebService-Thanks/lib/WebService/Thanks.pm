package WebService::Thanks;

use Any::Moose;
use Cache::FileCache;
use JSON;
use LWP::UserAgent;

our $VERSION = '0.01';

has 'api_key' => (
    is      => 'rw',
    isa     => 'Str'
);

has 'to_name' => (
    is      => 'rw',
    isa     => 'Str'
);

has 'tag' => (
    is      => 'rw',
    isa     => 'Str'
);

has 'public' => (
    is      => 'rw',
    isa     => 'Str',
    require => 1,
    default => sub { 'n' }
);

has 'json' => (
    is      => 'ro',
    isa     => 'JSON',
    require => 1,
    default => sub {
               my $self = @_;
               JSON->new();
    },
);

has 'ua' => (
    is      => 'ro',
    isa     => 'LWP::UserAgent',
    require => 1,
    default => sub {
               my $self = @_;
               my $ua   = LWP::UserAgent->new();
               $ua->timeout(10);
               $ua;
    },
);

has 'domain' => (
    is      => 'ro',
    isa     => 'Str',
    require => 1,
    default => sub { 'thanks.kayac.com' },
);


sub say {
    my ( $self, $attr ) = @_;
    my $to_name = $attr->{to_name} || $self->to_name;
    my $body    = $attr->{body};
    my $tag     = $attr->{tag} || $self->tag;
    my $public  = $attr->{public} || $self->public;

    unless ( $to_name, $body ) {
        return;
    }

    my $response = $self->ua->post('http://'.$self->domain.'/api/pub/say/thanks',{
        to_name => $to_name,
        body    => $body,
        tag     => $tag,
        public_yn  => $public,
        api_key => $self->api_key,
    });
    $self->_call_api($response);
}

sub say_guest {
    my ( $self, $attr ) = @_;
    my $to_name    = $attr->{to_name} || $self->to_name;
    my $guest_name = $attr->{guest_name};
    my $body    = $attr->{body};
    my $tag     = $attr->{tag} || $self->tag;
    my $public  = $attr->{public} || $self->public;

    unless ( $to_name, $body ) {
        return;
    }

    my $response = $self->ua->post('http://'.$self->domain.'/api/pub/say/guest_thanks',{
        to_name    => $to_name,
        guest_name => $guest_name,
        body       => $body,
        tag        => $tag,
        public_yn  => $public,
        api_key    => $self->api_key,
    });
    $self->_call_api($response);
}

sub read {
    my ( $self, $attr ) = @_;
    my $page = $attr->{page} || 1;

    my $response = $self->ua->post('http://'.$self->domain.'/api/pub/read/thanks',{
        page    => $page,
        api_key => $self->api_key,
    });
    $self->_call_api($response);
}

sub read_guest {
    my ( $self, $attr ) = @_;
    my $page = $attr->{page} || 1;

    my $response = $self->ua->post('http://'.$self->domain.'/api/pub/read/guest_thanks',{
        page    => $page,
        api_key => $self->api_key,
    });
    $self->_call_api($response);
}

sub delete {
    my ( $self, $attr ) = @_;
    my $id = $attr->{id};

    my $response = $self->ua->post('http://'.$self->domain.'/api/pub/delete/thanks',{
        id      => $id,
        api_key => $self->api_key,
    });
    $self->_call_api($response);
}

sub _call_api {
    my ( $self, $response ) = @_;

    if ( $response->is_success ) {
        warn $response->content;
        #return $self->json->jsonToObj($response->content);
        return $self->json->decode($response->content);
    }
    else {
        warn $response->content;
        return;
    }
}

1;
__END__

=head1 NAME

WebService::Thanks -

=head1 SYNOPSIS

  use WebService::Thanks;

=head1 DESCRIPTION

WebService::Thanks is

=head1 AUTHOR

use parent
Akihito Takeda E<lt>takeda.akihito@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
