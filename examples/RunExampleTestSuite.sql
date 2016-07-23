--Shows how to create a test suite in code and call the test runner.
--No tables are used for this.   
--Suite Management packages are when developed will make this easier.
--Clear Screen
Set Serveroutput On Size Unlimited format truncated
set echo off
--install the example unit test packages
@@ut_exampletest.pks
@@ut_exampletest.pkb
@@ut_exampletest2.pks
@@ut_exampletest2.pkb

declare
  suite         ut_test_suite;
  testtoexecute ut_test;
  test_item     ut_test;
begin
  suite := ut_test_suite(a_suite_name => 'Test Suite Name' /*,a_items => ut_test_objects_list()*/);

  testtoexecute := ut_test(a_object_name        => 'ut_exampletest'
                          ,a_test_procedure     => 'ut_exAmpletest'
                          ,a_setup_procedure    => 'Setup'
                          ,a_teardown_procedure => 'tEardown');

  suite.add_item(testtoexecute);

  testtoexecute := ut_test(a_object_name        => 'UT_EXAMPLETEST2'
                          ,a_test_procedure     => 'UT_EXAMPLETEST'
                          ,a_setup_procedure    => 'SETUP'
                          ,a_teardown_procedure => 'TEARDOWN');

  suite.add_item(testtoexecute);
  suite.execute;

  -- No reporter used in this example so outputing the results manually.
  for test_idx in suite.items.first .. suite.items.last loop
    test_item := treat(suite.items(test_idx) as ut_test);
    dbms_output.put_line('---------------------------------------------------');
    dbms_output.put_line('Test:' || test_item.call_params.object_name || '.' || test_item.call_params.test_procedure);
    dbms_output.put_line('Result: ' || test_item.execution_result.result);
    dbms_output.put_line('Assert Results:');
    for i in 1 .. test_item.execution_result.get_elements_count loop
      dbms_output.put_line(i || ' - result: ' || test_item.execution_result.get_element(i).result);
      dbms_output.put_line(i || ' - Message: ' || test_item.execution_result.get_element(i).message);
    end loop;
  end loop;
  dbms_output.put_line('---------------------------------------------------');
end;
/

drop package ut_exampletest;
drop package ut_exampletest2;
