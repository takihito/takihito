#!/usr/bin/perl

use strict;
use warnings;

use forks;

my $LOCK = $ARGV[0] || '';
my $thread1  = threads->new(\&_thread ,1 ,$LOCK );
my $thread2  = threads->new(\&_thread ,2 ,$LOCK );
 
sub _thread {
    my $args = shift;
    my $lock = shift || '';

#    require DBI;
    use DBI;

    my $dbh = DBI->connect('dbi:mysql:sample', 'root',  '', { AutoCommit => 0, RaiseError => 1 });
    $dbh->do('BEGIN') if $lock;
    for (1..5) {

        sleep(1);
        my $sql = 'select id, point1, point2 from user_point';
        if ( $lock ) {
            $sql = 'select id, point1, point2 from user_point where id = 2 for update';
        }
        my $sth = $dbh->prepare($sql);
        $sth->execute();
        my ($id, $point1, $point2) = $sth->fetchrow_array();
        print "$args PID:$$ args:$args ($point1) ".time()." \n";

        sleep(1);
        $sql = "update user_point set point1 = $args where id = 2";
        $dbh->do($sql);
        
        sleep(1);
        $sql = 'select id, point1, point2 from user_point';
        $sth = $dbh->prepare($sql);
        $sth->execute();
        ($id, $point1, $point2) = $sth->fetchrow_array();
        print "$args    PID:$$ args:$args ($point1) ".time()." \n";
        $sth->finish;
    }
    $dbh->do('COMMIT');
    $dbh->disconnect;
}

$thread1->join();
$thread2->join();


__END__


