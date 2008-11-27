#!/usr/bin/perl

use strict;
use warnings;

use forks;
use Data::Dumper;

my $LOCK = $ARGV[0] || '';
my $thread1  = threads->new(\&_thread ,1 ,$LOCK );
my $thread2  = threads->new(\&_thread ,2 ,$LOCK );
 
sub _thread {
    my $args = shift;
    my $lock = shift || '';
    my $id   = 2;
    #my $id  = $args;

    require DBIx::Simple;

    my $db = DBIx::Simple->connect('dbi:mysql:sample', 'root',  '', { AutoCommit => 0, RaiseError => 1 });

    $db->dbh->do('BEGIN') if $lock;
    my $connection_id = '';
    my $info = $db->query('SHOW PROCESSLIST');
    $connection_id = $info->hash->{id};
    for (1..3) {
        my ($i,$j);
        my $sql = "select id, point1, point2 from point where id = $id ";
        if ( $lock ) {
            $sql = "select id, point1, point2 from point where id = $id for update";
        }
        my $result = $db->query($sql);
        my $colums = $result->hash;
        $i = $colums->{point1};

        sleep(3);
        $sql = "update point set point1 = point1 + 1 where id = $id";
        $result = $db->query($sql);
        
        $sql = "select id, point1, point2 from point where id = $id";
        $result = $db->query($sql);
        $colums = $result->hash;
        $j = $colums->{point1};
        print  "$$ id:$id ($i,$j) connection_id:$connection_id\n";
        $result->finish;
    }
    print "commit\n";
    $db->dbh->do('COMMIT');
    $db->dbh->{'_fbav'}  = undef;
    $db->dbh->{'Active'} = 0;
    $db->dbh->disconnect;
}

print "start\n";
$thread1->join();
sleep(1);
$thread2->join();
print "end\n";


__END__

