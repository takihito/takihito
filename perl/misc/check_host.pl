#!/usr/bin/perl

use warnings;
use strict;

use Net::SSH::Perl;
use Getopt::Long;
use YAML;

## sample.yml
# servers:
#   - host: example.com 
#     user: username
#     password: passwd
#   - host: example.org
#     user: username
#     :
#
# ----------
#
# ex)
# ./check_host.pl -f sample.yml
#

my $file;
my $result = GetOptions ("file=s" => \$file);# yaml 

unless ( $file ) {
    warn "Not found config file \n";
    exit();
}

my $yml = YAML::LoadFile($file);
my $server = $yml->{servers};

for my $s (@{$server}) {
    my $hosts = call_ssh($s->{host}, $s->{user}, $s->{password});

    print map {
        $hosts->{allow}->{$_}?$hosts->{name}.",allow,($_),".$hosts->{allow}->{$_}."\n":""
    } %{$hosts->{allow}};

    print map {
        $hosts->{deny}->{$_}?$hosts->{name}.",deny,($_),".$hosts->{deny}->{$_}."\n":""
    } %{$hosts->{deny}};
}


sub call_ssh {
    my ( $host, $user, $pass ) = @_;

    my $ssh = Net::SSH::Perl->new($host);
    $ssh->login($user, $pass);
    
    my $hosts = {name => $host};

    # ALLOW
    my $cmd = 'cat /etc/hosts.allow';
    my ($stdout, $stderr, $exit) = $ssh->cmd($cmd);

    my $allow_service = {};
    while ($stdout =~ s/^(.+?):\ (.+)\n$//m ) {
        $allow_service->{$1} .= "$2 ";
    }
    $hosts->{allow} = $allow_service;

    
    # DENY
    $cmd = 'cat /etc/hosts.deny';
    ($stdout, $stderr, $exit) = $ssh->cmd($cmd);

    my $deny_service = {};
    while ($stdout =~ s/^(.+?):\ (.+)\n$//m ) {
        $deny_service->{$1} .= "$2 ";
    }
    $hosts->{deny} = $deny_service;

    return $hosts;
}

