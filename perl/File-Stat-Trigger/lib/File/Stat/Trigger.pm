package File::Stat::Trigger;

use Moose;
use Moose::Util::TypeConstraints;

use File::Stat::OO;
use Class::Trigger;
use DateTime;
use DateTime::Format::DateParse;

our $VERSION = '0.01';

subtype 'FileStat'
    => as 'Object'
    => where { $_->isa('File::Stat::OO') };

coerce 'FileStat'
    => from 'Str',
    => via { File::Stat::OO->new({ file => $_  }) };

subtype 'DateTime'
    => as 'Object'
    => where { $_->isa('DateTime') };
      
coerce 'DateTime'
    => from 'Str'
    => via { DateTime::Format::DateParse->parse_datetime($_) };

has 'file_stat' => (is => 'rw', isa => 'FileStat', coerce  => 1);

has [ qw<check_atime check_mtime check_ctime> ] =>
    ( is  => 'rw', isa => 'DateTime', coerce  => 1);

has 'check_size' => ( is  => 'rw', isa => 'Int');

has 'file' => ( is  => 'rw', isa => 'Str');

sub BUILD {
    my ($self,$attr) = @_;

    $self->file_stat(File::Stat::OO->new({ file => $self->file }));

    $self->file_stat->use_datetime(1);
    $self->file_stat->stat;

    $self->check_atime( $self->file_stat->atime )
      unless $self->check_atime;
    $self->check_mtime( $self->file_stat->mtime )
      unless $self->check_mtime;

    $self->check_ctime( $self->file_stat->ctime )
      unless $self->check_ctime;

    $self->check_size( $self->file_stat->size )
      unless $self->check_size;

}

sub scan {
    my ($self,$type, $code) = @_;

    my $result;
    for ( qw( size_trigger atime_trigger mtime_trigger ctime_trigger ) ){ 
        $result->{$_} = 0;
    }

    $self->file_stat->use_datetime(1);
    $self->file_stat->stat($self->file);

    if ( $self->file_stat->size != $self->check_size ) {
        $result->{size_trigger} = $self->call_trigger('size_trigger',$self);
        $self->check_size($self->file_stat->size);
    }

    for my $st_time ( qw(atime mtime ctime) ) {
        my $check_method = 'check_'.$st_time;#  check_atime or check_mtime or check_ctime
        if ( $self->file_stat->$st_time->epoch != $self->$check_method->epoch ) {
            $result->{$st_time.'_trigger'} = $self->call_trigger($st_time.'_trigger',$self);
            $self->$check_method($self->file_stat->$st_time);
        }
    }

#    if ( $self->file_stat->atime->epoch != $self->check_atime->epoch ) {
#        $result->{atime_trigger} = $self->call_trigger('atime_trigger',$self);
#        $self->check_atime($self->file_stat->atime);
#    }
#
#    if ( $self->file_stat->mtime->epoch != $self->check_mtime->epoch ) {
#        $result->{mtime_trigger} = $self->call_trigger('mtime_trigger',$self);
#        $self->check_mtime($self->file_stat->mtime);
#    }
#
#    if ( $self->file_stat->ctime->epoch != $self->check_ctime->epoch ) {
#        $result->{ctime_trigger} = $self->call_trigger('ctime_trigger',$self);
#        $self->check_ctime($self->file_stat->ctime);
#    }

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
