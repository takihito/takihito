
use strict;
use Test::More tests => 5;

BEGIN { use_ok 'File::Stat::Trigger' }

my $fs = File::Stat::Trigger->new({
 file        => 't/sample.txt',
 check_atime => '2008/11/20 12:00:00',
# check_mtime => '2008/11/20 12:00:00',
# check_ctime => '2008/11/20 12:00:00',
 check_size  => 1024,

});

ok($fs->size_trigger( sub {
        my $self = shift;
        my $i = $self->file_stat->size;    
        my $j = $self->check_size;
    } ));

ok($fs->atime_trigger(\&sample));

my $result = $fs->scan();

is($result->{size_trigger},1,'Not Call size_trigger');
is($result->{atime_trigger},1,'Not Call atime_trigger');

sub sample {
     my $fs = shift;
     print 'file.atime:'.$fs->file_stat->atime->ymd('-')."\n";
     print 'check_atime:'.$fs->check_atime."\n";
#     $fs->check_atime->epoch;    
#     $fs->file->mtime;
#     $fs->check_mtime->epoch;    
#     $fs->file->ctime;
#     $fs->check_ctime->epoch;
     return 1;
}

