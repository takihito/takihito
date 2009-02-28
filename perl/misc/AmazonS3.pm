package AmazonS3;

use Net::Amazon::S3;
use IO::All;
use Moose;

has 'aws_access_key_id'     => ( is => 'rw', isa => 'Str' );
has 'aws_secret_access_key' => ( is => 'rw', isa => 'Str' );
has 'bucket_name'           => ( is => 'rw', isa => 'Str' );
has 'bucket'                => ( is => 'rw', isa => 'Net::Amazon::S3::Bucket' );
has 's3'                    => ( is => 'rw', isa => 'Net::Amazon::S3', lazy_build => 1 );
has 'content_type'          => ( is => 'rw', isa => 'Str', default=>'audio/mp3' );
has 'cache_control'         => ( is => 'rw', isa => 'Str', default=>'max-age=31556926' );
has 'x_amz_acl'             => ( is => 'rw', isa => 'Str', default=>'public-read' );

__PACKAGE__->meta->make_immutable;

no Moose;

sub _build_s3 {
    my $self = shift;

    Net::Amazon::S3->new({
        aws_access_key_id     => $self->aws_access_key_id,
        aws_secret_access_key => $self->aws_secret_access_key,
        retry                 => 1,
    });
}

sub create_bucket{ 
    my ( $self, $bucket_name ) = @_;

    $self->bucket_name($bucket_name) if $bucket_name;
    $self->bucket($self->s3->bucket($self->bucket_name));

    $self->bucket;
}

sub upload{
    my ( $self, $name, $file ) = @_;

    $self->create_bucket();

    my $contents;
    io($file) > $contents;

    $self->bucket->add_key($name, $contents,
          {
            content_type    => $self->content_type,
            'cache-control' => $self->cache_control,
            'x-amz-acl'     => $self->x_amz_acl
          },
    );
}  
