use inc::Module::Install;
name 'HTTP-Engine-Middleware-Hormone';
all_from 'lib/HTTP/Engine/Middleware/Hormone.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
