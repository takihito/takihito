package File::Stat::Trigger;

use Moose;
use Moose::Util::TypeConstraints;

use File::Stat::Moose;
use Class::Trigger;
use DateTime;
use DateTime::Format::DateParse;

our $VERSION = '0.01';

subtype 'FileStat'
    => as 'Object'
    => where { $_->isa('File::Stat::Moose') };

coerce 'FileStat'
    => from 'Str | FileHandle | CacheFileHandle | OpenHandle',
    => via { File::Stat::Moose->new( file => $_ ) };

subtype 'DateTime'
    => as 'Object'
    => where { $_->isa('DateTime') };
      
coerce 'DateTime'
    => from 'Str'
    => via { DateTime::Format::DateParse->parse_datetime($_) };

has 'file' => (is => 'rw', isa => 'FileStat', coerce  => 1);

has [ qw<check_atime check_mtime check_ctime> ] =>
    ( is  => 'rw', isa => 'DateTime', coerce  => 1);

has 'check_size' => ( is  => 'rw', isa => 'Int');

has 'file_name' => ( is  => 'rw', isa => 'Str');

sub BUILD {
    my ($self,$attr) = @_;

    $self->file_name($attr->{file});

    $self->check_atime( $self->_epoch2dt($self->file->atime) )
      unless $self->check_atime;

    $self->check_mtime( $self->_epoch2dt($self->file->ctime) )
      unless $self->check_mtime;

    $self->check_ctime( $self->_epoch2dt($self->file->ctime) )
      unless $self->check_ctime;

    $self->check_size( $self->file->size )
      unless $self->check_size;

}

sub check {
    my ($self,$type, $code) = @_;

    my $result;
    for ( qw( size_trigger atime_trigger mtime_trigger ctime_trigger ) ){ 
        $result->{$_} = 0;
    }

    my $fs = File::Stat::Moose->new( file => $self->file_name );
    $self->file($fs);

    if ( $self->file->size != $self->check_size ) {
        $result->{size_trigger} = $self->call_trigger('size_trigger',$self);
        $self->check_size($self->file->size);
    }

    if ( $self->file->atime != $self->check_atime->epoch ) {
        $result->{atime_trigger} = $self->call_trigger('atime_trigger',$self);
        $self->check_atime($self->_epoch2dt($self->file->atime));
    }

    if ( $self->file->mtime != $self->check_mtime->epoch ) {
        $result->{mtime_trigger} = $self->call_trigger('mtime_trigger',$self);
        $self->check_mtime($self->_epoch2dt($self->file->mtime));
    }

    if ( $self->file->ctime != $self->check_ctime->epoch ) {
        $result->{ctime_trigger} = $self->call_trigger('ctime_trigger',$self);
        $self->check_ctime($self->_epoch2dt($self->file->ctime));
    }

    return $result;
}

sub size_trigger {
    my ($self, $code) = @_;
    $self->_trigger('size_trigger', $code);
}

sub atime_trigger {
    my ($self, $code) = @_;
    $self->_trigger('atime_trigger', $code);
}

sub mtime_trigger {
    my ($self, $code) = @_;
    $self->_trigger('mtime_trigger', $code);
}

sub ctime_trigger {
    my ($self, $code) = @_;
    $self->_trigger('ctime_trigger', $code);
}

sub _trigger {
    my ($self, $type, $code) = @_;
    $self->add_trigger($type,$code);
}

sub _epoch2dt{
    my ($self, $epoch) = @_;
    my $dt = DateTime->from_epoch( epoch => $epoch );
    return $dt;
}

1;
__END__

=head1 NAME

File::Stat::Trigger -

=head1 SYNOPSIS

  use File::Stat::Trigger;

=head1 DESCRIPTION

File::Stat::Trigger is

=head1 AUTHOR

Akihito Takeda E<lt>takeda.akihito@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
