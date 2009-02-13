use strict;
use warnings;

package main;

use Data::Dumper;

my ($db_name, $data_source, $user, $password ,$attr) =
 ('sample_x','dbi:mysql:sample','root','', {RaiseError => 1, AutoCommit => 0, PrintError => 0, Taint => 1});

# Class-wide methods.
Foo->set_db($db_name, $data_source, $user, $password, $attr);
Foo->set_sql('InsertPoint', 'insert into point (point1,point2) values (99,111)', 'sample_x');


# Class-wide methods.
#Foo->set_db($db_name, $data_source, $user, $password, $attr);

my $obj = Foo->db_sample_x;

my $sth = Foo->sql_InsertPoint();
$sth->execute();
$obj->commit();
$obj->disconnect();


package Foo;

use base 'Ima::DBI';


1;

