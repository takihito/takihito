use inc::Module::Install;
name 'WebService-Thanks';
all_from 'lib/WebService/Thanks.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
