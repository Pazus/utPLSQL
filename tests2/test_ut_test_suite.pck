create or replace package test_ut_test_suite is

  --%suite(ut_test)
  --%suitepath(ut_plsql.core)
  
  --%test(Test failure in beforeall procedure)
  --%beforetest(prep_failing_beforeall_test)
  --%aftertest(clean_failing_beforeall_test)  
  procedure failing_beforeall_test;
  procedure prep_failing_beforeall_test;
  procedure clean_failing_beforeall_test;  
  
  --%test(Test failure in beforeeach procedure)
  --%beforetest(prep_failing_beforeeach)
  --%aftertest(clean_failing_beforeeach)  
  procedure failing_beforeeach;
  procedure prep_failing_beforeeach;
  procedure clean_failing_beforeeach;  
  
  --%test(Test failure in beforetest procedure)
  --%beforetest(prep_failing_before_test)
  --%aftertest(clean_failing_before_test)  
  procedure failing_before_test;
  procedure prep_failing_before_test;
  procedure clean_failing_before_test;  
  
  --%test(Test failure in aftertest procedure)
  --%beforetest(prep_failing_after_test)
  --%aftertest(clean_failing_after_test)  
  procedure failing_after_test;
  procedure prep_failing_after_test;
  procedure clean_failing_after_test;
  
  --%test(Test failure in aftereach procedure)
  --%beforetest(prep_failing_aftereach)
  --%aftertest(clean_failing_aftereach)  
  procedure failing_aftereach;
  procedure prep_failing_aftereach;
  procedure clean_failing_aftereach;
  
  --%test(Test failure in afterall procedure)
  --%beforetest(prep_failing_afterall)
  --%aftertest(clean_failing_afterall)  
  procedure failing_afterall;
  procedure prep_failing_afterall;
  procedure clean_failing_afterall;
  
  --%test(Disable whole suite by disabled flag)
  --%beforetest(prep_suite_disabled)
  --%aftertest(clean_suite_disabled)
  procedure suite_disabled; 
  procedure prep_suite_disabled; 
  procedure clean_suite_disabled;    
  
  --%test(Test failure on invalid package body)
  --%beforetest(prep_failing_invalid_body)
  --%aftertest(clean_failing_invalid_body)  
  procedure failing_invalid_body;
  procedure prep_failing_invalid_body;
  procedure clean_failing_invalid_body;  
  
  --%test(Test failure on no package body)
  --%beforetest(prep_failing_no_body)
  --%aftertest(clean_failing_no_body)  
  procedure failing_no_body;
  procedure prep_failing_no_body;
  procedure clean_failing_no_body;  

  --%beforeall
  procedure prepare;
  
  --%afterall
  procedure cleanup;

end test_ut_test_suite;
/
create or replace package body test_ut_test_suite is


  ex_obj_doesnt_exist exception;
  pragma exception_init(ex_obj_doesnt_exist, -04043);
  
  /*
  procedure suite_disabled is
    l_output_data       dbms_output.chararr;
    l_num_lines         integer := 100000;
    l_output            clob;
    --pragma autonomous_transaction;
  begin
    -- should be refactored
    
    ut.run(':tmp_disabled');

    --assert
    dbms_output.get_lines( l_output_data, l_num_lines);
    dbms_lob.createtemporary(l_output,true);
    for i in 1 .. l_num_lines loop
      dbms_lob.append(l_output, l_output_data(i));
    end loop;
    
    ut.expect(l_output).to_be_like('%0 failed, 0 errored, 1 disabled, 0 warning(s)%');
    execute immediate 'begin ut.expect(tmp_disabled_suite_package.gv_var).to_be_null; end;';
    rollback;
    
    
  end;
  */
  /*procedure suite_disabled is
    l_suite ut_logical_suite;
    l_test ut_test;
    l_parsing_result ut_annotations.typ_annotated_package;
    l_expected ut_annotations.typ_annotated_package;
    l_ann_param ut_annotations.typ_annotation_param;
    l_cnt number;
    l_listener ut_event_listener := ut_event_listener(ut_reporters());
  begin

    execute immediate 'delete from ut$test_table';

    l_test := ut_test(a_object_name => 'ut_transaction_control',a_name => 'test', a_rollback_type => ut_utils.gc_rollback_auto);
    l_suite := ut_suite (a_description => 'Suite name', a_name => 'UT_TRANSACTION_CONTROL', a_object_name => 'UT_TRANSACTION_CONTROL', a_rollback_type => ut_utils.gc_rollback_auto,a_path => 'ut_transaction_control');
    l_suite.add_item(l_test);
    l_suite.set_disabled_flag(true);

  --Act
    l_suite.do_execute(l_listener);
    ut_assert_processor.clear_asserts;

  --Assert
    execute immediate q'[begin ut.expect(ut_transaction_control.count_rows('t')).to_equal(0); end;]';
    ut.expect(l_suite.result).to_equal(ut_utils.tr_disabled);
  end;*/
  
  procedure failing_beforeall_test is
    l_output_data       dbms_output.chararr;
    l_num_lines         integer := 100000;
    l_output            clob;
  begin
    --act
    ut.run('failing_beforeall_test');
    dbms_output.get_lines( l_output_data, l_num_lines);
    dbms_lob.createtemporary(l_output,true);
    for i in 1 .. l_num_lines loop
      dbms_lob.append(l_output,l_output_data(i));
    end loop;
    
    execute immediate 'begin ut.expect(failing_beforeall_test.gv_glob_val,''test1 was executed even though the beforeall failed'').to_equal(0); end;';
    ut.expect(l_output,'test1 was not marked as failed').tO_be_like('%2 tests, 0 failed, 2 errored%');
  end;
  
  procedure prep_failing_beforeall_test is
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package failing_beforeall_test as
  --%suite
  gv_glob_val number := 0;
  --%beforeall
  procedure before_all;
  --%test
  procedure test1;
  --%test
  procedure test2;
end;';
execute immediate 'create or replace package body failing_beforeall_test as
  procedure before_all is begin gv_glob_val := 1/0; end;
  procedure test1 is begin gv_glob_val := 1; ut.expect(1).to_equal(2); end;
  procedure test2 is begin gv_glob_val := 2; ut.expect(1).to_equal(2); end;
end;';
  end;
  procedure clean_failing_beforeall_test is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package failing_beforeall_test';
  end;
  
  procedure failing_beforeeach is
    l_output_data       dbms_output.chararr;
    l_num_lines         integer := 100000;
    l_output            clob;
  begin
    --act
    ut.run('failing_beforeeach');
    dbms_output.get_lines( l_output_data, l_num_lines);
    dbms_lob.createtemporary(l_output,true);
    for i in 1 .. l_num_lines loop
      dbms_lob.append(l_output,l_output_data(i));
    end loop;
    
    execute immediate 'begin ut.expect(failing_beforeeach.gv_glob_val,''test1 was executed even though the beforeeach failed'').to_equal(0); end;';
    ut.expect(l_output,'test1 was not marked as failed').tO_be_like('%2 tests, 0 failed, 2 errored%');
  end;
  
  procedure prep_failing_beforeeach is
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package failing_beforeeach as
  --%suite
  gv_glob_val number := 0;
  --%beforeeach
  procedure before_each;
  --%test
  procedure test1;
  --%test
  procedure test2;
end;';
execute immediate 'create or replace package body failing_beforeeach as
  procedure before_each is begin gv_glob_val := 1/0; end;
  procedure test1 is begin ut.expect(1).to_equal(2); end;
  procedure test2 is begin ut.expect(1).to_equal(2); end;
end;';
  end;
  
  procedure clean_failing_beforeeach is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package failing_beforeeach';
  end;
  
  procedure failing_before_test is
    l_output_data       dbms_output.chararr;
    l_num_lines         integer := 100000;
    l_output            clob;
  begin
    --act
    ut.run('failing_before_test');
    dbms_output.get_lines( l_output_data, l_num_lines);
    dbms_lob.createtemporary(l_output,true);
    for i in 1 .. l_num_lines loop
      dbms_lob.append(l_output,l_output_data(i));
    end loop;
    
    execute immediate 'begin ut.expect(failing_before_test.gv_glob_val,''test1 was executed even though the beforetest failed'').to_equal(0); end;';
    ut.expect(l_output,'test1 was not marked as failed').tO_be_like('%2 tests, 0 failed, 1 errored%');
  end;
  
  procedure prep_failing_before_test is
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package failing_before_test as
  --%suite
  gv_glob_val number := 0;
  procedure before_test1;
  --%test
  --%beforetest(before_test1)
  procedure test1;
  --%test
  procedure test2;
end;';
execute immediate 'create or replace package body failing_before_test as
  procedure before_test1 is begin gv_glob_val := 1/0; end;
  procedure test1 is begin gv_glob_val := 1; ut.expect(1).to_equal(2); end;
  procedure test2 is begin ut.expect(1).to_equal(1); end;
end;';
  end;
  
  procedure clean_failing_before_test is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package failing_before_test';
  end;  
  
  procedure failing_after_test is
    l_output_data       dbms_output.chararr;
    l_num_lines         integer := 100000;
    l_output            clob;
  begin
    --act
    ut.run('failing_after_test');
    dbms_output.get_lines( l_output_data, l_num_lines);
    dbms_lob.createtemporary(l_output,true);
    for i in 1 .. l_num_lines loop
      dbms_lob.append(l_output,l_output_data(i));
    end loop;
    
    execute immediate 'begin ut.expect(failing_after_test.gv_glob_val,''Failed: test1 was not executed'').to_equal(1); end;';
    ut.expect(l_output,'Failed: test1 was not marked as failed').tO_be_like('%2 tests, 0 failed, 1 errored%');
  end;
  
  procedure prep_failing_after_test is
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package failing_after_test as
  --%suite
  gv_glob_val number := 0;
  --%test
  --%aftertest(after_test1)
  procedure test1;
  procedure after_test1;
  --%test
  procedure test2;
end;';
execute immediate 'create or replace package body failing_after_test as
  procedure test1 is begin gv_glob_val := 1; ut.expect(1).to_equal(2); end;
  procedure after_test1 is begin gv_glob_val := 1/0; end;
  procedure test2 is begin ut.expect(1).to_equal(1); end;
end;';
  end;
  
  procedure clean_failing_after_test is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package failing_after_test';
  end;
  
  procedure failing_aftereach is
    l_output_data       dbms_output.chararr;
    l_num_lines         integer := 100000;
    l_output            clob;
  begin
    --act
    ut.run('failing_aftereach');
    dbms_output.get_lines( l_output_data, l_num_lines);
    dbms_lob.createtemporary(l_output,true);
    for i in 1 .. l_num_lines loop
      dbms_lob.append(l_output,l_output_data(i));
    end loop;
    
    execute immediate 'begin ut.expect(failing_aftereach.gv_glob_val,''Not all tests were executed'').to_equal(2); end;';
    ut.expect(l_output,'Not all tests were marked as failed').tO_be_like('%2 tests, 0 failed, 2 errored%');
  end;  
  
  procedure prep_failing_aftereach is
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package failing_aftereach as
  --%suite
  gv_glob_val number := 0;
  --%test
  procedure test1;
  --%test
  procedure test2;
  --%aftereach
  procedure after_each;
end;';
execute immediate 'create or replace package body failing_aftereach as
  procedure test1 is begin gv_glob_val := gv_glob_val + 1; ut.expect(1).to_equal(2); end;
  procedure test2 is begin gv_glob_val := gv_glob_val + 1; ut.expect(1).to_equal(2); end;
  procedure after_each is begin gv_glob_val := 1/0; end;
end;';
  end;
  procedure clean_failing_aftereach is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package failing_aftereach';
  end;  
  
  procedure failing_afterall is
    l_output_data       dbms_output.chararr;
    l_num_lines         integer := 100000;
    l_output            clob;
  begin
    --act
    ut.run('failing_afterall');
    dbms_output.get_lines( l_output_data, l_num_lines);
    dbms_lob.createtemporary(l_output,true);
    for i in 1 .. l_num_lines loop
      dbms_lob.append(l_output,l_output_data(i));
    end loop;
    
    execute immediate 'begin ut.expect(failing_afterall.gv_glob_val,''Not all tests were executed'').to_equal(2); end;';
    ut.expect(l_output,'Not all tests were marked as failed').tO_be_like('%2 tests, 2 failed, 0 errored% 1 warning%');
  end;  
  
  procedure prep_failing_afterall is
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package failing_afterall as
  --%suite
  gv_glob_val number := 0;
  --%test
  procedure test1;
  --%test
  procedure test2;
  --%afterall
  procedure after_all;
end;';
execute immediate 'create or replace package body failing_afterall as
  procedure test1 is begin gv_glob_val := gv_glob_val + 1; ut.expect(1).to_equal(2); end;
  procedure test2 is begin gv_glob_val := gv_glob_val + 1; ut.expect(1).to_equal(2); end;
  procedure after_all is begin gv_glob_val := 1/0; end;
end;';
  end;
  procedure clean_failing_afterall is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package failing_afterall';
  end;  
  
  procedure suite_disabled is
    l_output_data       dbms_output.chararr;
    l_num_lines         integer := 100000;
    l_output            clob;
  begin
    --act
    ut.run(':test_disabled');
    dbms_output.get_lines( l_output_data, l_num_lines);
    dbms_lob.createtemporary(l_output,true);
    for i in 1 .. l_num_lines loop
      dbms_lob.append(l_output,l_output_data(i));
    end loop;
    
    execute immediate 'begin ut.expect(suite_disabled.gv_glob_val,''Not all tests were executed'').to_equal(0); end;';
    ut.expect(l_output,'Not all tests were marked as failed').to_be_like('%0 tests, 0 failed, 0 errored, 0 disabled%');
  end;  
  
  procedure prep_suite_disabled is
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package suite_disabled as
  --%suite
  --%disabled
  --%suitepath(test_disabled)
  
  gv_glob_val number := 0;
  --%test
  procedure test1;
  --%test
  procedure test2;

end;';
execute immediate 'create or replace package body suite_disabled as
  procedure test1 is begin gv_glob_val := gv_glob_val + 1; end;
  procedure test2 is begin gv_glob_val := gv_glob_val + 1; end;
end;';
  end;
  procedure clean_suite_disabled is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package suite_disabled';
  end;  
  
  procedure failing_invalid_body is
    l_output_data       dbms_output.chararr;
    l_num_lines         integer := 100000;
    l_output            clob;
  begin
    --act
    ut.run('failing_invalid_body');
    dbms_output.get_lines( l_output_data, l_num_lines);
    dbms_lob.createtemporary(l_output,true);
    for i in 1 .. l_num_lines loop
      dbms_lob.append(l_output,l_output_data(i));
    end loop;
    
    ut.expect(l_output).tO_be_like('%2 tests, 0 failed, 2 errored%');
    
  end;
  
  procedure prep_failing_invalid_body is
    ex_body_inv exception;
    pragma exception_init(ex_body_inv,-24344);
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package failing_invalid_body as
  --%suite
  gv_glob_val number := 0;
  --%beforeall
  procedure before_all;
  --%test
  procedure test1;
  --%test
  procedure test2;
end;';

  begin
    execute immediate 'create or replace package body failing_invalid_body as
    null;
  end;';
  exception
    when ex_body_inv then
      null;
  end;

  end;
  
  procedure clean_failing_invalid_body is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package failing_invalid_body';
  end;
  
  procedure failing_no_body is
    l_output_data       dbms_output.chararr;
    l_num_lines         integer := 100000;
    l_output            clob;
  begin
    --act
    ut.run('failing_no_body');
    dbms_output.get_lines( l_output_data, l_num_lines);
    dbms_lob.createtemporary(l_output,true);
    for i in 1 .. l_num_lines loop
      dbms_lob.append(l_output,l_output_data(i));
    end loop;
    
    ut.expect(l_output).tO_be_like('%2 tests, 0 failed, 2 errored%');
    
  end;
  
  procedure prep_failing_no_body is
    ex_body_inv exception;
    pragma exception_init(ex_body_inv,-24344);
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package failing_no_body as
  --%suite
  gv_glob_val number := 0;
  --%beforeall
  procedure before_all;
  --%test
  procedure test1;
  --%test
  procedure test2;
end;';
  /*
  begin
    execute immediate 'create or replace package body failing_no_body as
    null;
  end;';
  exception
    when ex_body_inv then
      null;
  end;
  */
  end;
  
  procedure clean_failing_no_body is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package failing_no_body';
  end;
  
  procedure create_disabled_package is
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package tmp_disabled_suite_package is
    
  --%suite
  --%suitepath(tmp_disabled)
  --%disabled
  
  gv_var number;
  
  --%test
  procedure test;
  
  end;';
    execute immediate 'create or replace package body tmp_disabled_suite_package is
  procedure test is begin gv_var := 1; end;
  end;';
  end;
  
  procedure drop_disable_package is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package tmp_disabled_suite_package';
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

end test_ut_test_suite;
/
