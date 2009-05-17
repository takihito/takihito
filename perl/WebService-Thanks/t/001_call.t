use strict;
use Test::More qw(no_plan);

use WebService::Thanks;

use Data::Dumper;
if ( $ENV{THANKS_API_KEY} ) {
    my $thx = WebService::Thanks->new({
        'api_key' => $ENV{THANKS_API_KEY},
        'to_name' => 'kayac',
        'tag'     => 'sample',
        'public'  => 'n',
    });
    isa_ok($thx, 'WebService::Thanks');

    my $thanks; 
    $thanks = $thx->say({
      to_name => 'To THANKS',
      body    => 'THANKS!!',
      tag     => 'thanks',
    });
 
    $thanks = $thx->say_guest({
      to_name    => 'To THANKS',
      guest_name => 'guest san',
      body       => 'THANKS!!',
      tag        => 'thanks',
    });
 
    $thanks = $thx->read();
    for my $e ( @{$thanks->{entry}} ) {
        $e->{to_name};
        $e->{guest_name};
        $e->{body};
        $e->{tag};
    }
    is $thanks->{items_per_page}, 1, 'check items_per_page';
 
    $thanks = $thx->read_guest();
    for my $e ( @{$thanks->{entry}} ) {
        $e->{to_name};
        $e->{guest_name};
        $e->{body};
        $e->{tag};
    }
    is $thanks->{items_per_page}, 1, 'check items_per_page';

    $thanks = $thx->delete($thanks->{id});

}
