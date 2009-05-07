use strict;
use warnings;
use lib '.';
use Test::Base;

eval q{ use MIME::Types };
plan skip_all => "MIME::Types is not installed" if $@;
eval q{ use Path::Class };
plan skip_all => "Path::Class is not installed" if $@;
eval q( { package foo; use Any::Moose;use Any::Moose 'X::Types::Path::Class' } );
plan skip_all => "Mo[ou]seX::Types::Path::Class is not installed" if $@;

plan tests => 3 * blocks;

use HTTP::Engine;
use HTTP::Engine::Middleware;
use HTTP::Engine::Response;
use HTTP::Request;

sub run_tests {
    my($block, $mw) = @_;

    my $request = HTTP::Request->new(
        GET => $block->uri
    );

    my $response = HTTP::Engine->new(
        interface => {
            module          => 'Test',
            request_handler => $mw->handler( sub { HTTP::Engine::Response->new( body => 'dynamic' ) } ),
        },
    )->run($request);

    is $response->code, $block->code, 'status code';
    is $response->content_type, $block->content_type, 'content type';
    my $body = $block->body;
warn "BODY $body\n";
warn "RESPONSE ".$response->content." \n";
    like $response->content, qr/$body/, 'body';
}

run {
    my $block = shift;

    my @config = (
        'HTTP::Engine::Middleware::Hormone' => {
            config  => 't/sample.yaml',
        },
    );

    my $mw = HTTP::Engine::Middleware->new;
    $mw->install(@config);
    ok scalar(@{ $mw->middlewares }), 'firast instance';

    run_tests($block, $mw);

    my $mw2 = HTTP::Engine::Middleware->new;
    $mw2->install(@config);
    ok scalar(@{ $mw2->middlewares }), 'create multi instance';

    run_tests($block, $mw2);

    my @config2 = (
        'HTTP::Engine::Middleware::Hormone' => {
            config  => 't/sample.yaml',
        },
    );

    my $mw3 = HTTP::Engine::Middleware->new;
    $mw3->install(@config2);
    ok scalar(@{ $mw3->middlewares }), 'firast instance';

    run_tests($block, $mw3);
};


__END__

=== index
--- uri: http://localhost/
--- content_type: text/html
--- body: akihito
--- code: 200

=== foo1
--- uri: http://localhost/foo/bar/foo1
--- content_type: text/html
--- body: foo1
--- code: 200

=== foo2
--- uri: http://localhost/foo/bar/foo2
--- content_type: text/html
--- body: foo2
--- code: 200

=== tt
--- uri: http://localhost/foo/tt
--- content_type: text/html
--- body: AkihitoTakeda
--- code: 200

=== json
--- uri: http://localhost/foo/json
--- content_type: application/json
--- body: AkihitoTakeda
--- code: 200

=== not_found
--- uri: http://localhost/foo/not_found
--- content_type: text/html
--- body: not_found
--- code: 404

