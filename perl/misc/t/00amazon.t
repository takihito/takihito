use warnings;
use strict;
use Test::More qw(no_plan);
use Data::Dumper;

BEGIN { use_ok('AmazonS3'); }
#warn $ENV{aws_access_key_id}." \n";
#warn $ENV{aws_secret_access_key}." \n";
#warn $ENV{bucket_name}." \n";

my $amazon_s3 = AmazonS3->new({
    aws_access_key_id     => $ENV{aws_access_key_id},
    aws_secret_access_key => $ENV{aws_secret_access_key},
    bucket_name           => $ENV{bucket_name}, 
});

is(ref $amazon_s3, 'AmazonS3', 'ng new');

is(ref $amazon_s3->create_bucket(), 'Net::Amazon::S3::Bucket', 'ng bucket');

$amazon_s3->content_type('text/plain');
$amazon_s3->cache_control('max-age=10');
ok($amazon_s3->upload('test1.dat','test.dat'));

my $res = $amazon_s3->bucket->get_key('test1.dat');
is($res->{'cache-control'}, $amazon_s3->cache_control);
is($res->{'content_type'}, $amazon_s3->content_type);

#warn "cache-control ".$res->{'cache-control'}."\n";
#warn "content-type ".$res->{'content_type'}."\n";
#warn Dumper($amazon_s3->bucket->list_all);
