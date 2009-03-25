package Archer::Plugin::RemoteSVN;

use strict;
use warnings;
#use base qw/Archer::Plugin::Exec/;
use base qw/Archer::Plugin/;

use IO::Prompt;

sub run {
    my ( $self, $context, $args ) = @_;
    if ( $context->{ dry_run_fg } ) {
        $self->log( debug => "dry-run" );
    }
    else {
        $self->log( debug => "run!" );
        $self->_execute();
    }
}

sub _execute {
    my ($self, $cmd, $args) = @_;

    my $dir = $self->{config}->{svn_dir};
    while( prompt "svn_up> Input update dir:  " ) {
          $dir = $_ if $_;
          my $msg = "svn_up> target dir: ".$self->{config}->{user}.'@'
                    .$self->{server}.":$dir".' ? [y/n]';

          # rootディレクトリから指定する
          if ( $_ !~ /^\/.+/ ) {
              print "'$dir' is invalid !\n";
              next;
          }

          if ( IO::Prompt::prompt( $msg, '-yn' ) ) {
              last;
          }
    }

    $cmd = "svn up $dir";
    my $real_command = "ssh $self->{server} $cmd";
    $real_command = "sudo -u $self->{config}->{user} $real_command" if $self->{config}->{user};
    $self->log(debug => "real execute: $real_command");

    system $real_command; # XXX security!!!
}

1;
