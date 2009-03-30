#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use FCGI;
use FCGI::ProcManager qw(pm_manage pm_pre_dispatch pm_post_dispatch);

my $port    = 4500;
my $status  = 503;
my $process = 10;

my $sock = FCGI::OpenSocket(':'.$port, 100);
my $request = FCGI::Request(\*STDIN, \*STDOUT, \*STDERR, \%ENV, $sock, 1 );

pm_manage( n_processes => $process );

my $q = new CGI();

while($request->Accept() >= 0) {
    print $q->header(-type => 'text/plain', -status => $status);
    print "\n\nmentenance...\n\n";
}

__END__

perl fcgi_sample.pl

