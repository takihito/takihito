package HTTP::Engine::Middleware::Hormone;

use HTTP::Engine::Middleware;
use HTTP::Engine::Response;

use MIME::Types;
use Path::Class;
use Cwd;
use Any::Moose 'X::Types::Path::Class';
use Any::Moose '::Util::TypeConstraints';
use YAML::Syck;

our $VERSION = '0.01';

subtype 'YAML::Syck'
    => as 'HashRef';

coerce 'YAML::Syck'
    => from 'Str' => via { YAML::Syck::LoadFile($_) };

has 'file'       => (
    is => 'rw', isa =>'Str'
);

has 'res_config' => (
    is         => 'rw',
    isa        => 'HashRef',
    lazy       => 1,
    builder    => '_builder_res_config'
);

has 'config'     => (
    is       => 'rw',
    isa      => 'YAML::Syck',
    coerce   => 1,
    required => 1,
);

sub _builder_res_config {
    my ($self) = @_;

    my $res_config = {};
    for my $res ( @{$self->config->{response}} ) {
        $res_config->{$res->{path}} = $res;
    }

    $res_config;
}

before_handle {
    my ( $c, $self, $req ) = @_;

    for my $res ( @{$self->config->{response}} ) {
#        $self->res_config->{$res->{path}} = $res;
#warn $res->{path}." res path ---- \n";
    }


#    my $re   = $self->regexp;
#    my $uri_path = $req->uri->path;
#    return $req unless $uri_path && $uri_path =~ /^(?:$re)$/;
#
#    my $docroot = dir($self->docroot)->absolute;
#    my $file = do {
#        if ($uri_path =~ m{/$} && $self->directory_index) {
#            $docroot->file(
#                File::Spec::Unix->splitpath($uri_path),
#                $self->directory_index
#            );
#        } else {
#            $docroot->file(
#                File::Spec::Unix->splitpath($uri_path)
#            )
#        }
#    };
#
#    # check directory traversal
#    my $realpath = Cwd::realpath($file->absolute->stringify);
#    return HTTP::Engine::Response->new( status => 403, body => 'forbidden') unless $docroot->subsumes($realpath);
#
#    return HTTP::Engine::Response->new( status => '404', body => 'not found' ) unless -e $file;
#
#    my $content_type = 'text/plain';
#    if ($file =~ /.*\.(\S{1,})$/xms ) {
#        $content_type = $self->mime_types->mimeTypeOf($1)->type;
#    }
#
#    my $fh = $file->openr;
#    die "Unable to open $file for reading : $!" unless $fh;
#    binmode $fh;

#    my $res = HTTP::Engine::Response->new( body => $fh, content_type => $content_type );
    my $res = HTTP::Engine::Response->new( body => 'akihito' );
#    my $stat = $file->stat;
#    $res->header( 'Content-Length' => $stat->size );
#    $res->header( 'Last-Modified'  => $stat->mtime );
    $res;
};

__MIDDLEWARE__

__END__

=head1 NAME

HTTP::Engine::Middleware::Hormone -

=head1 SYNOPSIS

  use HTTP::Engine::Middleware::Hormone;

=head1 DESCRIPTION

HTTP::Engine::Middleware::Hormone is

=head1 AUTHOR

Akihito Takeda E<lt>takeda.akihito@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
