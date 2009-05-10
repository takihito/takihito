package HTTP::Engine::Middleware::Hormone;
use HTTP::Engine::Middleware;
use HTTP::Engine::Response;

use MIME::Types;
use Path::Class;
use Cwd;
use Any::Moose 'X::Types::Path::Class';
use Any::Moose '::Util::TypeConstraints';
use YAML::Syck;
use Template;

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

before_handle {
    my ( $c, $self, $req ) = @_;

    my $path = $req->uri->path;

    unless ( $self->res_config->{$path} ) {
        return HTTP::Engine::Response->new( status => '404', body => 'NotFound' );
    }

    my $body;
    my $content_type;
    my $encoding = 'utf-8';
    if ( $self->res_config->{$path}->{body} ) {
        $body = $self->res_config->{$path}->{body};
    }
    elsif( $self->res_config->{$path}->{json} ) {
        eval {
            require JSON::XS;
            $body = JSON::XS->new->utf8->encode($self->res_config->{$path}->{stash});
        }; 
        if ( ($req->user_agent || '') =~ /Opera/ ) {
            $content_type = 'application/x-javascript';
        } else {
            $content_type = 'application/json';
        }
    }
    elsif( $self->res_config->{$path}->{template} ) {
        $content_type = 'text/html';
        my $tt = Template->new($self->config->{TT}->{config});
        $tt->process($self->res_config->{$path}->{template}, $self->res_config->{$path}->{stash}, \$body);
    }

    my $res = HTTP::Engine::Response->new( body => $body, content_type => $content_type );
    $res;
};

sub _builder_res_config {
    my ($self) = @_;

    my $res_config = {};
    for my $res ( @{$self->config->{response}} ) {
        $res_config->{$res->{path}} = $res;
    }

    $res_config;
}

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
