--This shows how the interna test engine works to test a single package.
--No tables are used for this and exceptions are handled better.
--Clear Screen
Set Serveroutput On Size Unlimited format truncated
set echo off
--install the example unit test packages
@@ut_exampletest.pks
@@ut_exampletest.pkb

declare
  simple_test ut_test;
begin

  simple_test := ut_test(a_object_name        => 'ut_exampletest'
                        ,a_test_procedure     => 'ut_exampletest'
                        ,a_test_name          => 'Simple test1'
                        ,a_owner_name         => user
                        ,a_setup_procedure    => 'setup'
                        ,a_teardown_procedure => 'teardown');

  simple_test.execute(ut_dbms_output_suite_reporter);
end;
/

drop package ut_exampletest;
