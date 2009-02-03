#!/usr/bin/perl

use strict;
use warnings;
use Net::Amazon::S3;

my $aws_access_key_id     = 'xxxxxxx';
my $aws_secret_access_key = 'zzzzzzz';

my $s3 = Net::Amazon::S3->new(
    {   aws_access_key_id     => $aws_access_key_id,
        aws_secret_access_key => $aws_secret_access_key,
        retry                 => 1,
    }
);

my $response = $s3->buckets;
my $akihito_bk;
foreach my $bucket ( @{ $response->{buckets} } ) {
    $akihito_bk = $bucket if $bucket->bucket eq 'akihito';
}

$akihito_bk->add_key_filename( 'sample.mp3', 'news.mp3',
      {
        content_type => 'audio/mp3',
        expires      => 'Sun, 14 Nov 2010 21:00:00 GMT',
        'x-amz-acl'  => 'public-read'
      },
) or die $s3->err . ": " . $s3->errstr;

$response = $akihito_bk->get_key('sample.mp3') or die $s3->err . ": " . $s3->errstr;
print "         expires: " . $response->{expires} . "\n";
print "  content length: " . $response->{content_length} . "\n";
print "    content type: " . $response->{content_type} . "\n";
print "            etag: " . $response->{etag} . "\n";
print "         content: " . $response->{value} . "\n";

__END__

 private―Owner gets FULL_CONTROL.

 public-read―Owner gets FULL_CONTROL and the anonymous principal is granted READ access.

 public-read-write―Owner gets FULL_CONTROL, 
 the anonymous principal is granted READ and WRITE access.

