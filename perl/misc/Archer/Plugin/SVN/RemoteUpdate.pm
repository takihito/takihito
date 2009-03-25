pckage Archer::Plugin::SVN::RmoteUpdate;

use strict;
use warnings;
use base qw( Archer::Plugin::SVN );

use SVN::Agent;

sub run {
    my ($self, $context, $args) = @_;

    my $path = $self->{config}->{path}
        || File::Spec->catfile($context->{config}->{global}->{work_dir}, $context->{project});
    $path = $self->templatize($path);

    my $svn = SVN::Agent->load({ path => $path });
    $svn->update;
}

