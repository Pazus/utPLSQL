create or replace package test_transaction_control is

  --%suite
  --%suitepath(ut_plsql.core)

  --%beforeall
  procedure prepare;
  
  --%afterall
  procedure cleanup;

  --%beforeeach
  procedure clear_temp;
  
  --%test(Test suite auto transaction control)
  procedure test_rollback_auto;  
  
  --%test(Test suite auto transaction control on failure)
  procedure test_rollback_auto_on_failure;
  
  --%test(Test suite manual transaction control)
  procedure test_rollback_manual;  
  
  --%test(Test Test suite manual transaction control on failure)
  procedure test_rollback_manual_on_fail;

end test_transaction_control;
/
create or replace package body test_transaction_control is

  ex_obj_doesnt_exist exception;
  pragma exception_init(ex_obj_doesnt_exist, -04043);
  
  procedure test_rollback_auto is

    l_suite ut_logical_suite;
    l_test ut_test;
    l_listener ut_event_listener := ut_event_listener(ut_reporters());
  begin

    l_test := ut_test(a_object_name => 'ut_transaction_control',a_name => 'test', a_rollback_type => ut_utils.gc_rollback_auto);
    l_suite := ut_suite (a_description => 'Suite name', a_name => 'UT_TRANSACTION_CONTROL', a_object_name => 'UT_TRANSACTION_CONTROL',a_path => 'ut_transaction_control', a_rollback_type => ut_utils.gc_rollback_auto,
               a_before_all_proc_name => 'setup');
    l_suite.add_item(l_test);

  --Act
    l_suite.do_execute(l_listener);

    ut_assert_processor.clear_asserts;

  --Assert
    ut.expect(l_suite.result,'Suite not executed successfully').to_equal(ut_utils.tr_success);
    execute immediate q'[begin ut.expect(ut_transaction_control.count_rows('t')).to_equal(0); end;]';
    execute immediate q'[begin ut.expect(ut_transaction_control.count_rows('s')).to_equal(0); end;]';

  end;
  
  procedure test_rollback_auto_on_failure is

    l_suite ut_logical_suite;
    l_test ut_test;
    l_listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
    
    l_test := ut_test(a_object_name => 'ut_transaction_control',a_name => 'test_failure', a_rollback_type => ut_utils.gc_rollback_auto);
    l_suite := ut_suite (a_description => 'Suite name', a_name => 'UT_TRANSACTION_CONTROL', a_object_name => 'UT_TRANSACTION_CONTROL',a_path => 'ut_transaction_control', a_rollback_type => ut_utils.gc_rollback_auto,
                             a_before_all_proc_name => 'setup');
    l_suite.add_item(l_test);

  --Act
    l_suite.do_execute(l_listener);

    ut_assert_processor.clear_asserts;

  --Assert
    ut.expect(l_suite.result,'Suite not executed successfully').to_equal(ut_utils.tr_error);
    execute immediate q'[begin ut.expect(ut_transaction_control.count_rows('t')).to_equal(0); end;]';
    execute immediate q'[begin ut.expect(ut_transaction_control.count_rows('s')).to_equal(0); end;]';

  end;
  
  procedure test_rollback_manual is

    l_suite ut_logical_suite;
    l_test ut_test;
    l_listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
    
    l_test := ut_test(a_object_name => 'ut_transaction_control',a_name => 'test', a_rollback_type => ut_utils.gc_rollback_manual);
    l_suite := ut_suite (a_description => 'Suite name', a_name => 'UT_TRANSACTION_CONTROL', a_object_name => 'UT_TRANSACTION_CONTROL',a_path => 'ut_transaction_control', a_rollback_type => ut_utils.gc_rollback_manual,
                             a_before_all_proc_name => 'setup');
    l_suite.add_item(l_test);

  --Act
    l_suite.do_execute(l_listener);

    ut_assert_processor.clear_asserts;

  --Assert
    ut.expect(l_suite.result,'Suite not executed successfully').to_equal(ut_utils.tr_success);
    execute immediate q'[begin ut.expect(ut_transaction_control.count_rows('t')).to_equal(1); end;]';
    execute immediate q'[begin ut.expect(ut_transaction_control.count_rows('s')).to_equal(1); end;]';

  end;  
  
  procedure test_rollback_manual_on_fail is

    l_suite ut_logical_suite;
    l_test ut_test;
    l_listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
    
    l_test := ut_test(a_object_name => 'ut_transaction_control',a_name => 'test_failure', a_rollback_type => ut_utils.gc_rollback_manual);
    l_suite := ut_suite (a_description => 'Suite name', a_name => 'UT_TRANSACTION_CONTROL', a_object_name => 'UT_TRANSACTION_CONTROL',a_path => 'ut_transaction_control', a_rollback_type => ut_utils.gc_rollback_manual,
                             a_before_all_proc_name => 'setup');
    l_suite.add_item(l_test);

  --Act
    l_suite.do_execute(l_listener);

    ut_assert_processor.clear_asserts;

  --Assert
    ut.expect(l_suite.result,'Suite not executed successfully').to_equal(ut_utils.tr_error);
    execute immediate q'[begin ut.expect(ut_transaction_control.count_rows('t')).to_equal(1); end;]';
    execute immediate q'[begin ut.expect(ut_transaction_control.count_rows('s')).to_equal(1); end;]';

  end;  
  
  procedure clear_temp is
  begin
    execute immediate 'delete from ut$test_table';
  end;

  procedure prepare is
    pragma autonomous_transaction;
  begin
    execute immediate 'create table ut$test_table (val varchar2(1))';
    execute immediate q'[create or replace package ut_transaction_control as

  function count_rows(a_val varchar2) return number;

  procedure setup;

  procedure test;
  
  procedure test_failure;

end;]';
    execute immediate q'[create or replace package body ut_transaction_control
as 

  function count_rows(a_val varchar2) return number is
    l_cnt number;
  begin
    select count(*) 
      into l_cnt 
      from ut$test_table t
     where t.val = a_val;
     
    return l_cnt;
  end;

  procedure setup is begin
    insert into ut$test_table values ('s');
  end;
  
  procedure test is
  begin
    insert into ut$test_table values ('t');
  end;
  
  procedure test_failure is
  begin
    insert into ut$test_table values ('t');
    --raise no_data_found;
    raise_application_error(-20001,'Error');
  end;
    
end;]';
  end;
  
  procedure cleanup is
    pragma autonomous_transaction;
  begin
    begin
      execute immediate 'drop package ut_transaction_control';
    exception
      when ex_obj_doesnt_exist then
        null;
    end;
    begin
      execute immediate 'drop table ut$test_table';
    exception
      when ex_obj_doesnt_exist then
        null;
    end;
  end;

end test_transaction_control;
/
