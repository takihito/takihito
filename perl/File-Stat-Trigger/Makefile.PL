use inc::Module::Install;
name 'File-Stat-Trigger';
all_from 'lib/File/Stat/Trigger.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
