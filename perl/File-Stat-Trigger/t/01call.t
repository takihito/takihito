
use strict;
use Test::More tests => 7;

BEGIN { use_ok 'File::Stat::Trigger' }

my $fs = File::Stat::Trigger->new({
 file        => 't/sample.txt',
 check_atime => ['>=','2008/11/20 12:00:00'],
 check_ctime => ['>='],
# check_mtime => ['<=', '2008/11/20 12:00:00'],
 check_size  => ['!=',1024],
 auto_stat   => 1,
});

ok($fs->size_trigger( sub {
        my $self = shift;
        my $i = $self->file_stat->size;    
        my $j = $self->_size;
    } ));

ok($fs->atime_trigger(\&sample));

my $result = $fs->scan();

is($result->{size_trigger},1,'Not Call size_trigger');
is($result->{atime_trigger},1,'Not Call atime_trigger');
is($result->{ctime_trigger},0,'Call ctime_trigger');
is($result->{mtime_trigger},0,'Call mtime_trigger');

sub sample {
     my $fs = shift;
     print 'file.atime:'.$fs->file_stat->atime->ymd('-')."\n";
     return 1;
}

