create or replace package test_ut_test is

  --%suite(ut_test)
  --%suitepath(ut_plsql.core)

  --%beforeeach
  procedure compile_test_package;
  --%aftereach
  procedure drop_test_package;
  
  --%beforeall
  procedure compile_transactioncontrol_pkg;
  --%afterall
  procedure drop_transactioncontrol_pkg;

  
  --%test(AfterEach executed)
  procedure aftereach_executed;
  
  --%test(AfterEach procedure name invalid)
  procedure aftereach_proc_name_inv;
  
  --%test(AfterEach procedure name null)
  procedure aftereach_proc_name_null;
  
  --%test(Invoke beforeeach procedure)
  procedure beforeeach_executed;
  
  --%test(Does not execute test and reports error when test beforeeach procedure name for a test is invalid)
  procedure beforeeach_proc_name_inv;
  
  --%test(Does not invoke setup procedure when beforeeach procedure name for a test is null)
  procedure beforeeach_proc_name_null;
  
  --%test(Ignore test by disabled flag)
  procedure ignode_disabled_test;
  
  --%test(Checks that rollback exception doesn't make run to fail)
  procedure rollback_doesnt_fail;
  
  --%test(Reports error when test owner name for a test is invalid)
  procedure error_on_inv_owner;
  
  --%test(Executes test in current schema when test owner name for a test is null)
  procedure execute_on_null_owner;
  
  --%test(Reports error when unit test package for a test is in invalid state)
  --%beforetest(compile_invalid_pck)
  --%aftertest(drop_invalid_pck)
  procedure test_invalid_package;
  procedure compile_invalid_pck;
  procedure drop_invalid_pck;
  
  --%test(Reports error when unit test package name for a test is invalid)
  procedure invalid_package_name;
  
  --%test(Reports error when unit test package name for a test is null)
  procedure null_package_name;
  
  --%test(Reports error when test procedure name for a test is invalid)
  procedure proc_name_invalid;
  
  --%test(Reports error when test procedure name for a test is null)
  procedure proc_name_null;
  
  --%test(Warn if rollback failed)
  --%beforetest(prep_rollback_fail)
  --%aftertest(cleanup_rollback_fail)
  procedure ReportWarningOnRollbackFailed;
  procedure prep_rollback_fail;
  procedure cleanup_rollback_fail;
  
  --%test(Test auto transaction control)
  procedure transact_control_auto;
  
  --%test(Test auto transaction control on failure)
  procedure transact_control_auto_on_fail;
  
  --%test(Test manual transaction control)
  procedure transact_control_manual;
  
  --%test(Test manual transaction control on failure)
  procedure transact_ctrl_manual_on_fail;
  
  --%test(Invoke setup procedure before test when setup procedure name is defined)
  procedure before_test_exec;
  
  --%test(Does not execute test and reports error when test setup procedure name for a test is invalid)
  procedure beforetest_name_invalid;
  

end test_ut_test;
/
create or replace package body test_ut_test is


  procedure aftereach_executed is
    simple_test ut_test := ut_test(
      a_object_name         => 'ut_example_tests'
      ,a_name     => 'ut_passing_test'
      ,a_after_each_proc_name => 'aftereach'
    );
    listener ut_event_listener := ut_event_listener(ut_reporters());
    l_result integer;
  begin
  --Act
    
    simple_test.do_execute(listener);
    l_result := ut_assert_processor.get_aggregate_asserts_result;
    ut_assert_processor.clear_asserts;
    
    ut.expect(l_result).to_equal(ut_utils.tr_success);
    execute immediate 'begin ut.expect(ut_example_tests.g_char2).to_equal(''F''); end;';
  end;
  
  procedure aftereach_proc_name_inv is
    simple_test ut_test := ut_test(
      a_after_each_proc_name => 'invalid setup name'
      ,a_object_name => 'ut_example_tests'
      ,a_name => 'ut_exampletest'
    );
    listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
    execute immediate q'[begin
    ut_example_tests.g_char := 'x';
    ut_example_tests.g_char2 := 'x';
    end;]';
    
  --Act
    simple_test.do_execute(listener);
    
  --Assert
    ut_assert_processor.clear_asserts;
    
    ut.expect(simple_test.result).to_equal(ut_utils.tr_error);
    execute immediate 'begin ut.expect(ut_example_tests.g_char2).to_equal(''x''); end;';
  end;
  
  procedure aftereach_proc_name_null is
    simple_test ut_test := ut_test(
      a_after_each_proc_name => null
      ,a_object_name => 'ut_example_tests'
      ,a_name => 'ut_passing_test'
    );
    listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
  --Act
    simple_test.do_execute(listener);
  --Assert
    ut_assert_processor.clear_asserts;
    ut.expect(simple_test.result).to_equal(ut_utils.tr_success);
    execute immediate 'begin ut.expect(ut_example_tests.g_char2).to_equal(''a''); end;';
  end;
  
  procedure beforeeach_executed is
    simple_test ut_test := ut_test(
      a_object_name            => 'ut_example_tests'
      ,a_name        => 'ut_passing_test'
      ,a_before_each_proc_name => 'beforeeach'
    );
    listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
  --Act
    simple_test.do_execute(listener);
    ut_assert_processor.clear_asserts;
  --Assert
    ut.expect(simple_test.result).to_equal(ut_utils.tr_success);
    execute immediate 'begin ut.expect(ut_example_tests.g_number2).to_equal(1); end;';
  end;
  
  procedure beforeeach_proc_name_inv is
    simple_test ut_test := ut_test(
       a_before_each_proc_name => 'invalid setup name'
      ,a_object_name => 'ut_example_tests'
      ,a_name => 'ut_exampletest'
    );
    listener ut_event_listener := ut_event_listener(ut_reporters());
    l_result integer;
  begin
  --Act
    simple_test.do_execute(listener);
    ut_assert_processor.clear_asserts;
  --Assert
    ut.expect(simple_test.result).to_equal(ut_utils.tr_error);
    execute immediate 'begin ut.expect(ut_example_tests.g_char2).to_be_null; end;';
  end;
  
  procedure beforeeach_proc_name_null is
    simple_test ut_test := ut_test(
       a_before_each_proc_name => null
      ,a_object_name => 'ut_example_tests'
      ,a_name => 'ut_passing_test'
    );
    listener ut_event_listener := ut_event_listener(ut_reporters());
    l_result integer;
  begin
  --Act
    simple_test.do_execute(listener);
    l_result := ut_assert_processor.get_aggregate_asserts_result;
    ut_assert_processor.clear_asserts;
  --Assert
    ut.expect(l_result).to_equal(ut_utils.tr_success);
    execute immediate 'begin ut.expect(ut_example_tests.g_number2).to_be_null; end;';
  end;
  
  procedure ignode_disabled_test is
    l_suite ut_logical_suite;
    l_test ut_test;
    l_parsing_result ut_annotations.typ_annotated_package;
    l_expected ut_annotations.typ_annotated_package;
    l_ann_param ut_annotations.typ_annotation_param;
    l_cnt number;
    l_listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
    
    execute immediate 'delete from ut$test_table';

    l_test := ut_test(a_object_name => 'ut_transaction_control', a_name => 'test', a_rollback_type => ut_utils.gc_rollback_auto, a_ignore_flag => true);
    l_suite := ut_suite (a_description => 'Suite name', a_name => 'UT_TRANSACTION_CONTROL', a_object_name => 'UT_TRANSACTION_CONTROL', a_rollback_type => ut_utils.gc_rollback_auto,a_path => 'ut_transaction_control');
    l_suite.add_item(l_test);

    --Act
    l_suite.do_execute(l_listener);

    ut_assert_processor.clear_asserts;

    --Assert
    ut.expect(l_suite.result).to_equal(ut_utils.tr_ignore);
    execute immediate q'[begin ut.expect(ut_transaction_control.count_rows('t')).to_equal(0); end;]';
  end;
  
  procedure rollback_doesnt_fail is
    simple_test ut_test := ut_test(a_object_name => 'ut_example_tests', a_name => 'ut_commit_test',a_rollback_type => ut_utils.gc_rollback_auto);
    listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
    --Act
    simple_test.do_execute(listener);
    --Assert
    ut.expect(simple_test.result).to_equal(ut_utils.tr_success);
  end;
  
  procedure error_on_inv_owner is
    simple_test ut_test := ut_test( a_object_owner => 'invalid owner name', a_object_name => 'ut_example_tests', a_name => 'ut_passing_test');
    listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
  --Act
    simple_test.do_execute(listener);

  --Assert
    ut.expect(simple_test.result).to_equal(ut_utils.tr_error);
  end;
  
  procedure execute_on_null_owner is
    simple_test ut_test:= ut_test(a_object_owner => null, a_object_name => 'ut_example_tests', a_name => 'ut_passing_test');
    listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
    --Act
    simple_test.do_execute(listener);
    --Assert
    ut.expect(simple_test.result).to_equal(ut_utils.tr_success);
    execute immediate q'[begin ut.expect(ut_example_tests.g_char).to_equal('a'); end;]';
  end;
  
  procedure test_invalid_package is
    simple_test ut_test := ut_test(a_object_name => 'invalid_package', a_name => 'ut_exampletest');
    listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
    --Act
    simple_test.do_execute(listener);
    --Assert
    ut.expect(simple_test.result).to_equal(ut_utils.tr_error);
  end;
  
  procedure invalid_package_name is
    simple_test ut_test := ut_test(a_object_name => 'invalid test package name', a_name => 'ut_passing_test');
    listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
    --Act
    simple_test.do_execute(listener);
    --Assert
    ut.expect(simple_test.result).to_equal(ut_utils.tr_error);
  end;
  
  procedure null_package_name is
    simple_test ut_test := ut_test(a_object_name => null, a_name => 'ut_passing_test');
    listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
    --Act
    simple_test.do_execute(listener);
    --Assert
    ut.expect(simple_test.result).to_equal(ut_utils.tr_error);
  end;
  
  procedure proc_name_invalid is
    simple_test ut_test := ut_test(a_object_name => 'ut_example_tests' ,a_name => 'invalid procedure name');
    listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
    --Act
    simple_test.do_execute(listener);
    --Assert
    ut.expect(simple_test.result).to_equal(ut_utils.tr_error);
  end;
  
  procedure proc_name_null is
    simple_test ut_test := ut_test(a_object_name => 'ut_example_tests' ,a_name => null);
    listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
    --Act
    simple_test.do_execute(listener);
    --Assert
    ut.expect(simple_test.result).to_equal(ut_utils.tr_error);
  end;
  
  procedure prep_rollback_fail is
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package ut_output_test_rollback
as
 --%suite
  
 --%test
 procedure tt;
 
end;';
  end;
  procedure cleanup_rollback_fail is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package ut_output_test_rollback';
  end;
  procedure ReportWarningOnRollbackFailed is
    l_output_data       dbms_output.chararr;
    l_num_lines         integer := 100000;
    l_output            clob;
  begin
    --act
    ut.run('ut_output_test_rollback');

    --assert
    dbms_output.get_lines( l_output_data, l_num_lines);
    dbms_lob.createtemporary(l_output,true);
    for i in 1 .. l_num_lines loop
      dbms_lob.append(l_output,l_output_data(i));
    end loop;
    
    ut.expect(l_output).to_be_like('%Warnings:%Savepoint not established. Implicit commit might have occured.%0 disabled, 1 warning(s)%');

  end;
  
  
  procedure transact_control_auto is
    l_suite ut_logical_suite;
    l_test  ut_test;
    l_parsing_result ut_annotations.typ_annotated_package;
    l_expected ut_annotations.typ_annotated_package;
    l_ann_param ut_annotations.typ_annotation_param;
    l_cnt number;
    l_listener ut_event_listener := ut_event_listener(ut_reporters());
  begin

    execute immediate 'delete from ut$test_table';

    l_test := ut_test(a_object_name => 'ut_transaction_control',a_name => 'test', a_rollback_type => ut_utils.gc_rollback_manual);
    l_suite := ut_suite (a_description => 'Suite name', a_name => 'UT_TRANSACTION_CONTROL', a_object_name => 'UT_TRANSACTION_CONTROL',a_rollback_type => ut_utils.gc_rollback_auto,a_path => 'ut_transaction_control');
    l_suite.add_item(l_test);

    --Act
    l_suite.do_execute(l_listener);

    ut_assert_processor.clear_asserts;

    --Assert
    ut.expect(l_suite.result).to_equal(ut_utils.tr_success);
    execute immediate q'[begin ut.expect(ut_transaction_control.count_rows('t')).to_equal(0); end;]';
  end;
  
  procedure transact_control_auto_on_fail is
    l_suite ut_logical_suite;
    l_test ut_test;
    l_parsing_result ut_annotations.typ_annotated_package;
    l_expected ut_annotations.typ_annotated_package;
    l_ann_param ut_annotations.typ_annotation_param;
    l_cnt number;
    l_listener ut_event_listener := ut_event_listener(ut_reporters());
  begin

    execute immediate 'delete from ut$test_table';

    l_test := ut_test(a_object_name => 'ut_transaction_control',a_name => 'test_failure', a_rollback_type => ut_utils.gc_rollback_manual);
    l_suite := ut_suite (a_description => 'Suite name', a_name => 'UT_TRANSACTION_CONTROL', a_object_name => 'UT_TRANSACTION_CONTROL', a_rollback_type => ut_utils.gc_rollback_auto,a_path => 'ut_transaction_control');
    l_suite.add_item(l_test);

  --Act
    l_suite.do_execute(l_listener);

    ut_assert_processor.clear_asserts;

  --Assert
    ut.expect(l_suite.result).to_equal(ut_utils.tr_error);
    execute immediate q'[begin ut.expect(ut_transaction_control.count_rows('t')).to_equal(0); end;]';

  end;    
  
  procedure transact_control_manual is
    l_suite ut_logical_suite;
    l_test ut_test;
    l_parsing_result ut_annotations.typ_annotated_package;
    l_expected ut_annotations.typ_annotated_package;
    l_ann_param ut_annotations.typ_annotation_param;
    l_cnt number;
    l_listener ut_event_listener := ut_event_listener(ut_reporters());
  begin

    execute immediate 'delete from ut$test_table';

    l_test := ut_test(a_object_name => 'ut_transaction_control',a_name => 'test', a_rollback_type => ut_utils.gc_rollback_manual);
    l_suite := ut_suite (a_description => 'Suite name', a_name => 'UT_TRANSACTION_CONTROL', a_object_name => 'UT_TRANSACTION_CONTROL', a_rollback_type => ut_utils.gc_rollback_manual,a_path => 'ut_transaction_control');
    l_suite.add_item(l_test);

    --Act
    l_suite.do_execute(l_listener);

    ut_assert_processor.clear_asserts;

    --Assert
    ut.expect(l_suite.result).to_equal(ut_utils.tr_success);
    execute immediate q'[begin ut.expect(ut_transaction_control.count_rows('t')).to_( be_greater_than(0) ); end;]';
  end;
  
  procedure transact_ctrl_manual_on_fail is
    l_suite ut_logical_suite;
    l_test ut_test;
    l_parsing_result ut_annotations.typ_annotated_package;
    l_expected ut_annotations.typ_annotated_package;
    l_ann_param ut_annotations.typ_annotation_param;
    l_cnt number;
    l_listener ut_event_listener := ut_event_listener(ut_reporters());
  begin

    execute immediate 'delete from ut$test_table';

    l_test := ut_test(a_object_name => 'ut_transaction_control',a_name => 'test_failure', a_rollback_type => ut_utils.gc_rollback_manual);
    l_suite := ut_suite (a_description => 'Suite name', a_name => 'UT_TRANSACTION_CONTROL', a_object_name => 'UT_TRANSACTION_CONTROL', a_rollback_type => ut_utils.gc_rollback_manual,a_path => 'ut_transaction_control');
    l_suite.add_item(l_test);
  --Act
    l_suite.do_execute(l_listener);

    ut_assert_processor.clear_asserts;

  --Assert
    ut.expect(l_suite.result).to_equal(ut_utils.tr_error);
    execute immediate q'[begin ut.expect(ut_transaction_control.count_rows('t')).to_( be_greater_than(0) ); end;]';
  end;
  
  procedure before_test_exec is
    simple_test ut_test := ut_test(
      a_object_name            => 'ut_example_tests'
      ,a_name        => 'ut_passing_test'
      ,a_before_test_proc_name => 'setup'
    );
    listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
  --Act
    simple_test.do_execute(listener);
    ut_assert_processor.clear_asserts;
  --Assert
    
    ut.expect(simple_test.result).to_equal(ut_utils.tr_success);
    execute immediate q'[begin ut.expect(ut_example_tests.g_number).to_equal(1); end;]';
  end;
  
  procedure beforetest_name_invalid is
    simple_test ut_test := ut_test(
       a_before_test_proc_name => 'invalid setup name'
      ,a_object_name => 'ut_example_tests'
      ,a_name => 'ut_exampletest'
    );
    listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
  --Act
    simple_test.do_execute(listener);
    ut_assert_processor.clear_asserts;
    
  --Assert
    ut.expect(simple_test.result).to_equal(ut_utils.tr_error);
    execute immediate q'[begin ut.expect(ut_example_tests.g_char).to_be_null; end;]';
  end;
  
  procedure beforetest_name_null is
    simple_test ut_test := ut_test(
       a_before_test_proc_name => null
      ,a_object_name => 'ut_example_tests'
      ,a_name => 'ut_passing_test'
    );
    listener ut_event_listener := ut_event_listener(ut_reporters());
  begin
  --Act
    simple_test.do_execute(listener);
  --Assert
    ut.expect(ut_example_tests.g_number).to_be_null;
    ut.expect(simple_test.result).to_equal(ut_utils.tr_success);

  end;
  
  procedure compile_invalid_pck is
    ex_compilation_error exception;
    pragma exception_init(ex_compilation_error,-24344);
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package invalid_package is
  v_variable non_existing_type;
  procedure ut_exampletest;
end;';
  exception 
    when ex_compilation_error then 
      null;
  end;
  
  procedure drop_invalid_pck is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package invalid_package';
  end;

  procedure compile_test_package is
    pragma autonomous_transaction;
  begin
    execute immediate q'[create or replace package ut_example_tests
as
 g_number  number;
 g_number2  number;
 g_char    varchar2(1);
 g_char2    varchar2(1);
 procedure setup;
 procedure teardown;
 procedure beforeeach;
 procedure aftereach;
 procedure ut_passing_test;
 procedure ut_commit_test;
end;]';
  execute immediate q'[create or replace package body ut_example_tests
as

 procedure setup as
 begin
   g_number := 0;
 end;

 procedure teardown
 as
 begin
    g_char := null;
 end;
 
 procedure beforeeach as
 begin
   g_number2 := 0;
 end;

 procedure aftereach
 as
 begin
    g_char2 := 'F';
 end;

 procedure ut_passing_test
 as
 begin
    g_number := g_number + 1;
    g_number2 := g_number2 + 1;
    g_char := 'a';
    g_char2 := 'a';
    ut.expect(1,'Test 1 Should Pass').to_equal(1);
 end;
 
 procedure ut_commit_test 
 is
 begin
   commit;
 end;

end;]';
  end;
  --%afterall
  procedure drop_test_package is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package ut_example_tests';
  end;
  
  --%beforeall
  procedure compile_transactioncontrol_pkg is
    ex_table_exists exception;
    pragma autonomous_transaction;
    pragma exception_init(ex_table_exists,-955);
  begin
    begin
      execute immediate 'create table ut$test_table (val varchar2(1))';
    exception
      when ex_table_exists then
        null;
    end;
    execute immediate 'create or replace package ut_transaction_control as
  function count_rows(a_val varchar2) return number;
  procedure setup;
  procedure test;
  procedure test_failure;
end;';
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
  --%afterall
  procedure drop_transactioncontrol_pkg is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package ut_transaction_control';
    for rec in (select table_name from user_tables t where table_name = 'UT$TEST_TABLE') loop
      execute immediate 'drop table '||rec.table_name;
    end loop;
  end;
  
end test_ut_test;
/
