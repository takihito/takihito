package WebService::Thanks;

use Any::Moose;
use Cache::FileCache;
extends 'LWP::UserAgent';

our $VERSION = '0.01';

has 'api_key' => (
    is      => 'ro',
    isa     => 'Str',
);


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
