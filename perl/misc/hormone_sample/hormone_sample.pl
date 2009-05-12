
use HTTP::Engine::Middleware;
use HTTP::Engine;

my $mw = HTTP::Engine::Middleware->new;
$mw->install(
     'HTTP::Engine::Middleware::Hormone' => {
         config  => 'sample.yaml',
     }
);

my $engine = HTTP::Engine->new(
    interface => {
        module => 'ServerSimple',
        args   => {
            host => '192.168.0.1',
            port =>  1978,
        },
        request_handler => $mw->handler( ),
    },
);
$engine->run;



